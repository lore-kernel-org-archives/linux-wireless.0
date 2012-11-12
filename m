Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48197 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab2KLVDh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 16:03:37 -0500
Message-ID: <50A16424.5080202@gmail.com> (sfid-20121112_220347_248289_5C84F05C)
Date: Mon, 12 Nov 2012 22:03:32 +0100
From: Andreas Philipp <philipp.andreas@gmail.com>
MIME-Version: 1.0
To: Corey Richardson <corey@octayn.net>
CC: linux-wireless@vger.kernel.org, vthiagar@qca.qualcomm.com,
	netdev@vger.kernel.org, jouni@qca.qualcomm.com,
	linville@tuxdriver.com, ath9k-devel@lists.ath9k.org
Subject: Re: [ath9k-devel] ath9k_htc-based adapter unfunctioning after commit
 ceb26a6013
References: <CA++BO6SuRgOu7A4BKobrdEeSpSc3UUYHXaECmEGE=R17w7HjQA@mail.gmail.com>
In-Reply-To: <CA++BO6SuRgOu7A4BKobrdEeSpSc3UUYHXaECmEGE=R17w7HjQA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am experiencing exactly the same problem. I will try to revert the
commit in question tomorrow and report the result.

Thanks,
Andreas Philipp

On 11/12/2012 02:34 PM, Corey Richardson wrote:
> I was giving 3.7-rc4 a whirl when I discovered my wireless adapter [0] wasn't
> working: the LED didn't light up. Went and ran 'ip link' and it just hung there.
> Tried a few other things and discovered that sudo was broken too. With
> strace I found that they were hanging in sendto().
>
> If I then unplug the adapter, everything comes out of the hang.
>
> Bisected and found that commit ceb26a6013b962b82f644189ea29d802490fc8fc is
> to blame.
>
> Attached is my .config,. The complete dmesg is attached, as well as
> dmesg_disconnect which is what gets spat out on disconnect of the device.
> strace is an strace of 'ip link'.
>
> I feel like I haven't given enough information; anything else needed?
>
> (Please CC me in any reply to a list; I am not subscribed to them)
>
> [0] - http://support.netgear.com/product/WNA1100
>
> --
> Corey Richardson
>
>
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel

