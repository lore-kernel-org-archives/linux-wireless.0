Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.243]:58822 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbYCGMcQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2008 07:32:16 -0500
Received: by an-out-0708.google.com with SMTP id d31so117073and.103
        for <linux-wireless@vger.kernel.org>; Fri, 07 Mar 2008 04:32:14 -0800 (PST)
Message-ID: <40f31dec0803070432i2e313b32q68493f0af4a0105c@mail.gmail.com> (sfid-20080307_123220_371098_5E7F97FB)
Date: Fri, 7 Mar 2008 14:32:14 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH 0/8] ath5k: latest revised patches
Cc: "John W. Linville" <linville@tuxdriver.com>,
	ath5k-devel@lists.ath5k.org, "Jiri Slaby" <jirislaby@gmail.com>,
	"Bob Copeland" <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890803061907j2dca57f1k6907e2942f8a70fc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890802281456j22236cdegb4cf0c90d954af05@mail.gmail.com>
	 <43e72e890803061907j2dca57f1k6907e2942f8a70fc@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/3/7, Luis R. Rodriguez <mcgrof@gmail.com>:
> On Thu, Feb 28, 2008 at 5:56 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>  > The following are based on Nick's patches, they address checkpatch
>  >  complaints, make use of pci_dev's is_pcie, and makes use of a helper
>  >  instead on the 7th patch. These need testing on pci-e cards. I've
>  >  tested it on AR5213 (MAC 0x56, PHY: 0x41), RF5211 (0x17) and RF2111
>  >  (0x23).
>
>
> Testing was done.
>
>
>  >  You can also wget them from:
>  >
>  >  http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath5k/2008-02-28/
>
>
> We need to move forward with this. Any blockers?
>
>
>   Luis
>

As i've told you in private, i'm not O.K. with the helper function you
introduced in 7/8 because:

a) It makes cross-reference with dumps more difficult for no reason.

b) It doesn't make sense to have a helper function for only one chip
and for only one single 5212-specific part of code. There is a lot of
chip-specific code in hw_reset, either we make a helper function for
each chip containing all chip-specific code or we leave it as it is -i
prefer the second since order there matters + it will make
cross-reference much more difficult-, grabbing just a small part of
chip-specific code and calling it a helper function for that chip
doesn't make sense and is misleading IMHO.

c) It doesn't make sense to introduce a small function that's only
called once + have the above issues just to avoid 80-column limit.

d) In general i don't think introducing a function for style-reasons
is a good practice since it's misleading and in fact makes code
readability worse.

so please resubmit that patch without the helper function and you'll
get my ACK (well it'll be my patch then + checkpatch fixes so
ACK/signed-off-by makes no difference :P).

As for the pci-e patch i've also told you what i think both public and
in private, however since a fix for these cards (2424/5424/2425) is
needed asap i'm ok with any given approach (mine + Bob's patch or
your's), so i leave it up to John to decide.

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
