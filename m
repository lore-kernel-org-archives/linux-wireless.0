Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:24168 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbYGGWos (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 18:44:48 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2295151wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2008 15:44:47 -0700 (PDT)
Subject: Re: [PATCH 1/1 V2] mac80211: Fix ieee80211_rx_reorder_ampdu:
	ignore QoS null packets
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>, linville@tuxdriver.com,
	johannes@sipsolutions.net, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1ba2fa240807071516m6220a15sf02fe0b954d0d4ae@mail.gmail.com>
References: <1215434881-5410-1-git-send-email-tomas.winkler@intel.com>
	 <1215447824.14247.2.camel@brick> <200807071902.51683.mb@bu3sch.de>
	 <1215458792.14247.7.camel@brick>
	 <1ba2fa240807071423n755d4e5ay81a6543be7761a92@mail.gmail.com>
	 <1215466987.14247.12.camel@brick>
	 <1ba2fa240807071516m6220a15sf02fe0b954d0d4ae@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 07 Jul 2008 15:44:45 -0700
Message-Id: <1215470685.14247.15.camel@brick> (sfid-20080708_004451_805370_EC0C0F0A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-07-08 at 01:16 +0300, Tomas Winkler wrote:
> On Tue, Jul 8, 2008 at 12:43 AM, Harvey Harrison
> > set.
> >
> I know but, what you missing is the check above. we bail out from the
> function if the packet is not qos data before so it's not relevant for
> checking
> of any null data just qos null data. I didn't want to touch the PS
> code that's why we've created a special handler for this particular
> case.
> I think you patch works as well  and maybe can be used  PS mode as
> well but I'm not sure now.. I will look at this alter.
> Tomas
> 

Good point, a helper probably isn't right for this as it's already been
checked that it's a data packet with qos, so opencoding the nullfunc
test is probably the right thing (as it was before my change).

if (unlikely(hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_NULLFUNC)))

Cheers,

Harvey

