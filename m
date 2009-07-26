Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:48514 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbZGZVdK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jul 2009 17:33:10 -0400
MIME-Version: 1.0
In-Reply-To: <1248639013.32168.15.camel@mj>
References: <c6b1100b0907130127g3d4013c6n3264f79bd74bc9@mail.gmail.com>
	 <c6b1100b0907140404h4fdbe419p8443da43350f3520@mail.gmail.com>
	 <c6b1100b0907210439jf67d886s3125dafa5f4d3928@mail.gmail.com>
	 <c6b1100b0907261215l71ada148y8a15f6595d939192@mail.gmail.com>
	 <1248639013.32168.15.camel@mj>
Date: Sun, 26 Jul 2009 22:33:08 +0100
Message-ID: <c6b1100b0907261433s5f069f8ck26861cef5239ef98@mail.gmail.com>
Subject: Re: 2.6.31-rc2: Possible regression in rt61pci driver
From: Chris Clayton <chris2553@googlemail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the reply, Pavel.

2009/7/26 Pavel Roskin <proski@gnu.org>:
> On Sun, 2009-07-26 at 20:15 +0100, Chris Clayton wrote:
>
>> One more data point. I wondered whether the freeze would "time out" if
>> I just left the laptop frozen, but my testing shows that it probably
>> does not (or if it does it takes more than 27 minutes to do so.
>
> I suggest that you run it on the text console after "dmesg -n 8", so
> that all kernel messages are seen.
>
> I'm using rt61pci with wireless-testing, and I don't see any freezes.

Do you have CONFIG_MAC80211_DEFAULT_PS enabled? I have just built and
installed -rc4 with this option disabled and it has survived almost 20
 minutes so far without a freeze. No previous kernel  in the 2.6.31
series has survived more than 5 minutes without freezing, so this
looks promising.
>
>> I've also tried to bisect again, but, as last time, once I got to the
>> batch of network-related changes that went into -rc1, I get a series
>> of kernels that build but either won't boot or have inoperable
>> wireless networking.
>
> You can use "git bisect skip" to skip those revisions.
>
> You can specify the paths in "git bisect start" so that only changes to
> the interesting places (like drivers/net wireless, net/mac80211 and
> net/wireless) are considered when calculating the next commit.  This
> will probably help you avoid the bad place.
>

 Thanks for those tips. I'll note them in my "useful stuff I might
forget" notebook and then try to find time over the next few weeks to
get to grips with the power of git.

Chris


-- 
No, Sir; there is nothing which has yet been contrived by man, by which
so much happiness is produced as by a good tavern or inn - Doctor Samuel
Johnson
