Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from jptorel01.sonyericsson.com ([124.215.201.70]:9790 "EHLO
	jptorel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752893AbbIWKVR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 06:21:17 -0400
Date: Wed, 23 Sep 2015 12:11:09 +0200
From: Lars Svensson <Lars1.Svensson@sonymobile.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: "Jes.Sorensen@redhat.com" <Jes.Sorensen@redhat.com>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"m.v.b@runbox.com" <m.v.b@runbox.com>,
	"gdonald@gmail.com" <gdonald@gmail.com>,
	"joe@perches.com" <joe@perches.com>,
	"ruchandani.tina@gmail.com" <ruchandani.tina@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: rtl8723au: Mark type casts to __le32 as
 intentional
Message-ID: <20150923101109.GA1107@sonymobile.com> (sfid-20150923_122135_842216_CB4DD6A7)
References: <1442906641-22824-1-git-send-email-lars1.svensson@sonymobile.com>
 <5601C88E.4010807@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5601C88E.4010807@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 22, 2015 at 11:30:54PM +0200, Larry Finger wrote:
> 
> You may have silenced the Sparse warnings, but the code was not wrong. Your 
> version is also correct; however, you end up with some really ugly casts.
> 
> Here is my analysis of these two, identical sections:
> 
> The output of getcrc32() is an unsigned, 4-byte quantity that has the endianess 
> of the cpu. Therefore, the le32_to_cpu() conversion is suspect for a big-endian 
> machine. Those statements should be be a simple "actual_crc = getcrc32(....).
> 
> The expected crc comes from a byte string that is in little-endian order. For 
> that reason, it needs to be converted on big-endian machines, which is exactly 
> what get_unaligned_le32() does. Thus, the second statement in each block becomes 
> "expected_crc = get_unaligned_le32(....)".
> 
> Both the original code and your patch byte swap both quantities, thus they get 
> the correct result. at least if all you are doing is to compare the two results.

I agree, it seems obvious when You spell it out like this. I was more
focused on producing an identical result while removing the sparse warnings. Your
suggestion is much nicer, I will change the patch accordingly.

> 
> The above compiles with no Sparse warnings, and I think it would work on both LE 
> and BE architectures; however, it has only been compile tested.

I have no big endian machine to try it on, but it seems reasonable to assume
that at least the compare will work. The printk in case of a mismatch im not
sure about, though. Assuming the analysis is correct, I think the printed values
would be wrong on a BE machine before this change?

Thanks,
//Lars
