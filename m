Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57076 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab2BOSfO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 13:35:14 -0500
Received: by vcge1 with SMTP id e1so962620vcg.19
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2012 10:35:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEcv57uTvTN-rddc7p2LPoU0Tv_V3PqWyYpM_NajmFB1OQ@mail.gmail.com>
References: <CAG6hwVNXru0bN+MZNf+vwN=LGFn9G8EpzK+A=FOCHwe0yYCbyQ@mail.gmail.com>
 <20120215040307.GA4387@shredder> <CAB3XZEcv57uTvTN-rddc7p2LPoU0Tv_V3PqWyYpM_NajmFB1OQ@mail.gmail.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Wed, 15 Feb 2012 10:34:53 -0800
Message-ID: <CAG6hwVPhox575NKk5mOx8Q8Eangk8sVvZAi7fembFBF1yk40ww@mail.gmail.com> (sfid-20120215_193522_873317_30977AEC)
Subject: Re: wl12xx: BUG: scheduling while atomic: kworker
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eliad,

On Wed, Feb 15, 2012 at 2:00 AM, Eliad Peller <eliad@wizery.com> wrote:
> On Wed, Feb 15, 2012 at 6:03 AM, Thomas Pedersen <thomas@cozybit.com> wrote:
>> Sorry, gmail ate the formatting. Resending:
>>
>> # [  151.065338] BUG: scheduling while atomic: kworker/0:1/425/0x00000200
>
>> [  151.249053] [<bf0f2170>] (wl12xx_sdio_raw_write+0x50/0xa4 [wl12xx_sdio]) from [<bf0c710c>] (wl1271_cm)
>> [  151.261260] [<bf0c710c>] (wl1271_cmd_send+0x80/0x3b4 [wl12xx]) from [<bf0c98f4>] (wl12xx_start_dev+0x)
>> [  151.272674] [<bf0c98f4>] (wl12xx_start_dev+0x90/0x144 [wl12xx]) from [<bf0cab2c>] (wl12xx_tx_get_hlid)
>> [  151.284179] [<bf0cab2c>] (wl12xx_tx_get_hlid+0xc8/0xcc [wl12xx]) from [<bf0c36c4>] (wl1271_op_tx+0x44)
>> [  151.284179] [<bf0c36c4>] (wl1271_op_tx+0x44/0x150 [wl12xx]) from [<bf059ce8>] (__ieee80211_tx.isra.4+)
>> [  151.307586] [<bf059ce8>] (__ieee80211_tx.isra.4+0x150/0x2c0 [mac80211]) from [<bf059f18>] (ieee80211_)
>> [  151.319702] [<bf059f18>] (ieee80211_tx+0xc0/0xf4 [mac80211]) from [<bf05a008>] (ieee80211_xmit+0xbc/0)
>> [  151.330841] [<bf05a008>] (ieee80211_xmit+0xbc/0x150 [mac80211]) from [<bf05b2a8>] (ieee80211_tx_skb_t)
>> [  151.342956] [<bf05b2a8>] (ieee80211_tx_skb_tid+0x3c/0x48 [mac80211]) from [<bf06f998>] (ieee80211_pro)
>> [  151.355773] [<bf06f998>] (ieee80211_probe_auth+0x128/0x2f8 [mac80211]) from [<bf073774>] (ieee80211_m)
>> [  151.355773] [<bf073774>] (ieee80211_mgd_auth+0x218/0x3b0 [mac80211]) from [<bf016e94>]
>
> this should be applied:
> http://permalink.gmane.org/gmane.linux.kernel.wireless.general/84311
>
> and you'll probably also need to apply
> http://permalink.gmane.org/gmane.linux.kernel.wireless.general/84312
>
> if you want your device to be able to connect :)
>

That did it, thanks!

Thomas
