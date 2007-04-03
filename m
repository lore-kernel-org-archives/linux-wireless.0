Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:50028 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966082AbXDCAHG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2007 20:07:06 -0400
Received: by ug-out-1314.google.com with SMTP id 44so109704uga
        for <linux-wireless@vger.kernel.org>; Mon, 02 Apr 2007 17:07:01 -0700 (PDT)
Message-ID: <1ba2fa240704021707l1964a2cav579a4665bf48fbc6@mail.gmail.com>
Date: Tue, 3 Apr 2007 03:07:00 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [patch 3/5] A-MSDU Rx aggregation support
Cc: mabbas <mabbas@linux.intel.com>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <1175539103.16379.3.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <1174909200.1364.56.camel@dell-4965.jf.intel.com>
	 <1175111599.5151.123.camel@johannes.berg>
	 <4611F47F.2060809@linux.intel.com>
	 <1175539103.16379.3.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

11n is QoS derived but it's not WME.
I think we should extract qos control filed and ht control fields from
header in pre-handlers
one of them is qos parser,  just it needs to save the qos fields on
the txrx data
This will be needed in both rx and tx path. With 11n there are few
other points in the code  that these fields need to be accessed.
You can query fc  whether this fields are set.

ieee80211_txrx_data
      u16 fc, ethertype;
+    u16 qos_ctrl; /* cpu  order */
+    u16 ht_ctrl;

The other option is to introduce again all the types of headers
24,26...32.  I don' t know real reason why they are not present in
mac80211 but it looks intentional.

Next option to avoid the blow up of header types we can use offset functions
int ieee80211_get_qosctl_offset(u16 fc)
int ieee80211_get_htctl_offset(u16 fc)
This will give consistent offset of these control fields but it still
won't work when you use this remove qos field handler.

Other thing is to change ieee80211_get_hdrlen function as the header
is longer now by other 2 octets (ht control field)

On 4/2/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2007-04-02 at 23:30 -0700, mabbas wrote:
>
> > I am calling ieee80211_rx_h_data_agg after ieee80211_rx_h_remove_qos_control which
> > clears all QoS data which include QOS_CONTROL_A_MSDU_PRESENT bit. We can solve this by
> > adding new field is_frame_agg to ieee80211_txrx_data.u.rx.is_frame_agg which will be set in
> > ieee80211_rx_h_parse_qos or we can add new function to ieee80211_rx_pre_handlers just to do that. the other
> > option is to shuffle calling sequence here if that possible to call ieee80211_rx_h_data_agg
> > before ieee80211_rx_h_remove_qos_control. any opinion?
>
> Since it's part of the QoS stuff that .11n adds I think we should stick
> it into the qos parser.
>
> johannes
>
>
