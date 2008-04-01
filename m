Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:51673 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbYDAStE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 14:49:04 -0400
Received: by wf-out-1314.google.com with SMTP id 28so2223209wff.4
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2008 11:49:03 -0700 (PDT)
Message-ID: <f6ca9fed0804011149wc306716xb49e1f5dc2791f7a@mail.gmail.com> (sfid-20080401_194909_591758_824F5338)
Date: Tue, 1 Apr 2008 20:49:02 +0200
From: drago01 <drago01@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [ipw3945-devel] dynamic wep with mulitple keys
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Dan Williams" <dcbw@redhat.com>, "Jouni Malinen" <j@w1.fi>
In-Reply-To: <1ba2fa240803312253l4595ce43ya3a6812ceb216f12@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <f6ca9fed0803311237w1b714034w8ba3cfd56aec9686@mail.gmail.com>
	 <1ba2fa240803312253l4595ce43ya3a6812ceb216f12@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 1, 2008 at 7:53 AM, Tomas Winkler <tomasw@gmail.com> wrote:
>
> On 3/31/08, drago01 <drago01@gmail.com> wrote:
>  > Hello,
>  >
>  > I noticed that I can connect to some dynamic wep APs fine using
>  > iwl3945 and with other it does not work, while ipw3945 work with all
>  > of them.
>  > Both driver associate fine but iwl3945 never gets an ip from dhcp.
>  > I checked with iwlist key and it seems that this APs are using only
>  > one key with iwl3945 but two with ipw3945.
>  > The APs that work (I recognize them by BSSID) are using only one key
>  > with both drivers.
>  > Does this mean that mac80211/iwl3945 for some reason drops one key or
>  > never sets it?  (broadcast key?)
>  > Any idea how to get more infos to debug this? (Can attach both iwlist
>  > key outputs if this is needed).
>
>  Currently iwl uses cryptom management provided by mac80211, we are
>  preparing patches for using of HW acceleration till now you must look
>  for
>  problems mac80211.

OK, Johannes any idea what it might be?

>  Some log prints will be useful to debug it anyway.

Which kind of logs exactly?
Tried adding debug=0x43fff and no usefull (related) stuff got printed.

(added some CC's)
