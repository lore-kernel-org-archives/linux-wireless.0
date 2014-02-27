Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:22902 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbaB0LiR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 06:38:17 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: set the mactime of ieee80211_rx_status
References: <1392197866-1261-1-git-send-email-yeohchunyeow@gmail.com>
	<877g8rxgyf.fsf@kamboji.qca.qualcomm.com>
	<CAEFj9870+z+2yxjO7F69bGv3XzKNmi+ddyF41WSnv2aR98kjrw@mail.gmail.com>
Date: Thu, 27 Feb 2014 13:38:11 +0200
In-Reply-To: <CAEFj9870+z+2yxjO7F69bGv3XzKNmi+ddyF41WSnv2aR98kjrw@mail.gmail.com>
	(Yeoh Chun-Yeow's message of "Thu, 20 Feb 2014 10:47:45 +0800")
Message-ID: <87ob1sg50c.fsf@kamboji.qca.qualcomm.com> (sfid-20140227_123821_448154_C1282733)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yeoh Chun-Yeow <yeohchunyeow@gmail.com> writes:

>> Why? Where do you need tsf exactly? And what bug are you actually fixing
>> here?
>
> There are two type of configuration modes that require local TSF, IBSS
> and mesh for operation and also monitor mode.
>
> For IBSS, it is use for merging of BSSID (mac address) with same SSID
> name, but currently this is taking care by the following "ugly" patch.
> http://lists.infradead.org/pipermail/ath10k/2014-February/001159.html
>
> Mesh mode needs this for more accurate synchronization purpose.
>
> Besides, the monitor mode requires this to add extra piece of
> information in radiotap header for local TSF.
>
>> Do we get some regressions because of proving only a 32 bit TSF? Which
>> one is better, provide a 32-bit TSF or not at all?
>
> 32-bit is not good. It could cause problem when inter-operate with
> other non-ath10k drivers with 64-bit local TSF.

Yeah, I understand that. But my question is will we create regressions
if I apply this patch which provides only 32-bit TSF? I guess not as we
haven't provided TSF at all before, but I would like to be sure.

> The better is that we can get the 64-bit local TSF. providing high TSF
> and low TSF as found in "struct wmi_comb_phyerr_rx_hd". Is this
> possible with current FW?

I'm not familiar with the firmware so I sent a question to the firmware
team about this.

-- 
Kalle Valo
