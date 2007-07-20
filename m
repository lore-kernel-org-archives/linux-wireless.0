Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:57623 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752679AbXGTGFq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2007 02:05:46 -0400
Message-ID: <46A050B4.3060500@warmcat.com>
Date: Fri, 20 Jul 2007 07:05:40 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@lwfinger.net>,
	johannes@sipsolutions.net
Subject: Re: [PATCH 2/2] bcm43xx-mac80211: Fix reported rx frequency and channel
References: <20070611103828.961999956@warmcat.com> <20070611103914.577674038@warmcat.com> <20070719191052.GC6603@tuxdriver.com> <200707192139.14930.mb@bu3sch.de>
In-Reply-To: <200707192139.14930.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

:
> On Thursday 19 July 2007 21:10:52 John W. Linville wrote:
>> On Mon, Jun 11, 2007 at 11:38:30AM +0100, andy@warmcat.com wrote:
>>> bcm43xx-mac80211 is reporting bogus frequencies and channels back to
>>> mac80211 at the moment (eg, actual ch1 (2412MHz) reported as 2424MHz).
>>>
>>> Prior to this patch, the hardware rx channel value is reported as
>>> starting at 0x18 and rising by 0x0a per channel.  Code in bcm43xx_xmit.c
>>> tries to take this value and add 2400 to it to get the rx frequency.
>>> It seems the intention is that the hardware reports the (rx freq - 2400),
>>> so we want the value starting at 0x0c and rising by 0x05 per channel.
>>>
>>> If the value read is shifted one more bit to the right, it will
>>> succeed in doing this.  Therefore this patch increases the shifting constant
>>> by one and reduces the mask by one lsb.
>>>
>>> The rx frequency reported in the radiotap rx and then, eg, tcpdump,
>>> is then correct.  I didn't test ch 14 but I guess the hardware is
>>> consistent about it.
>>>
>>> CC: Larry Finger <larry.finger@lwfinger.net>
>>> CC: Michael Buesch <mb@bu3sch.de>
>>> Signed-off-by: Andy Green <andy@warmcat.com>
>> Larry, Michael, Johannes -- ack/nak?
> 
> nak, the issue is more difficult than this.

Although for this and the zd1211rw patch I found out they were
deprecated/more complex already using a "polling method",
I must say an explicit ACK or NAK for patches is a great idea.

After seeing patch tracking issues on arm-linux mailing list as well,
those not involving me, I started making a PHP project called
"patchfillet" for the purpose of extracting patches from a mailing list
and trying to track the patch lifecycle in an automated way driven by
the contents of the threads (eg, keywords like adding Acked-by: <blah>
in a reply) and maybe one day by looking at an upstream git repo commits
(I found that the Index: line in git-committed patches can change
destroying what would otherwise be a hash match).

The idea is it generates dynamic HTML on a website, and once it can be
trusted enough mails reports to the same mailing list about patches
without a resolution, patches accepted and rejected for the week and so
on.  Right now it is able to extract all the patches, inline or
attached, from an IMAP server folder into a MySQL database along with
message ID and thread info, and to run patches against an external git
tree and checkpatch.pl.  If this is interesting to anyone by all means
send me ideas for what is useful on or off list.

> The point is that firmware changed and we don't know the exact revision, yet.
> But it is actually no problem in reality, as the use-it-or-die
> firmware doesn't have this problem. So if someone uses another
> firmware than the one we suggest, he will probably run into more
> problems, as well.
> The fix is called: Use the correct firmware.
> For now, at least.
> 
> Of course, the author of this patch should help us to find
> out the exact firmware rev where this change happened. So we
> can come up with a real fix.

I never heard of a special blessed firmware before, I don't think that
the driver made any dmesg when given the non-blessed one, if that is
what it is?  I was given this firmware by the traditional "person on
IRC" and don't know where it came from, but I still have it here if any
versioning can be extracted from it.

Unfortunately the only sport I practice is one I named "extreme admin".
 This involves maintaining Fedora installs on the machines of remote
friends and relatives during infrequent visits.  My bcm43xx card is
currently living with my In-laws in Spain (and doing fine using
bcm43xx-mac80211 ;-) ).

-Andy

