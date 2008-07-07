Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:55097 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950AbYGGXB1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 19:01:27 -0400
Received: by py-out-1112.google.com with SMTP id p76so1042242pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2008 16:01:24 -0700 (PDT)
Message-ID: <1ba2fa240807071601s79590b3cpe0974b15a0aab18@mail.gmail.com> (sfid-20080708_010143_756334_87DF4D37)
Date: Tue, 8 Jul 2008 02:01:23 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Harvey Harrison" <harvey.harrison@gmail.com>
Subject: Re: [PATCH 1/1 V2] mac80211: Fix ieee80211_rx_reorder_ampdu: ignore QoS null packets
Cc: "Michael Buesch" <mb@bu3sch.de>, linville@tuxdriver.com,
	johannes@sipsolutions.net, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <1215470685.14247.15.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1215434881-5410-1-git-send-email-tomas.winkler@intel.com>
	 <1215447824.14247.2.camel@brick> <200807071902.51683.mb@bu3sch.de>
	 <1215458792.14247.7.camel@brick>
	 <1ba2fa240807071423n755d4e5ay81a6543be7761a92@mail.gmail.com>
	 <1215466987.14247.12.camel@brick>
	 <1ba2fa240807071516m6220a15sf02fe0b954d0d4ae@mail.gmail.com>
	 <1215470685.14247.15.camel@brick>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 8, 2008 at 1:44 AM, Harvey Harrison
<harvey.harrison@gmail.com> wrote:
> On Tue, 2008-07-08 at 01:16 +0300, Tomas Winkler wrote:
>> On Tue, Jul 8, 2008 at 12:43 AM, Harvey Harrison
>> > set.
>> >
>> I know but, what you missing is the check above. we bail out from the
>> function if the packet is not qos data before so it's not relevant for
>> checking
>> of any null data just qos null data. I didn't want to touch the PS
>> code that's why we've created a special handler for this particular
>> case.
>> I think you patch works as well  and maybe can be used  PS mode as
>> well but I'm not sure now.. I will look at this alter.
>> Tomas
>>
>
> Good point, a helper probably isn't right for this as it's already been
> checked that it's a data packet with qos, so opencoding the nullfunc
> test is probably the right thing (as it was before my change).
>
> if (unlikely(hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_NULLFUNC)))
>
> Cheers,

Sound reasonable will drop this patch in favor of the open code.
Thanks
Tomas
