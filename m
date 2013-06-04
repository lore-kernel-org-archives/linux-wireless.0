Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3543 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154Ab3FDM67 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 08:58:59 -0400
Message-ID: <51ADE47D.50700@broadcom.com> (sfid-20130604_145904_002860_D92B03BE)
Date: Tue, 4 Jun 2013 14:58:37 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Stephen Warren" <swarren@wwwdotorg.org>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: Regression in 9390ace brcmfmac: free net device when
 registration fails
References: <51AD1F22.2080004@wwwdotorg.org>
In-Reply-To: <51AD1F22.2080004@wwwdotorg.org>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/04/2013 12:56 AM, Stephen Warren wrote:
> (John, note that this commit is part of the pull request you sent to
> Dave today)
>
> Arend,
>
> Commit 9390ace "brcmfmac: free net device when registration fails"
> causes a regression.
>
> I had the BCM4330 firmware present in my root fs, whereas my HW is a
> BCM4329. With this patch applied, I get a kernel panic on boot. With it
> reverted, I see that no issues of that nature. This is true in
> next-20130531 (and also 5/30 and 6/1 but not earlier). A bisect of
> Linus's tree followed by a merge of John's wireless pull request from
> today pointed at this same commit.

Thanks, Stephen

I will look into this.

> Related: Since the two hardware require different firmware, I wonder why
> the driver doesn't use a firmware filename that encodes the HW device ID
> instead of using the same name for all HW. This means that when I move
> my SD card between development systems, I have to copy different
> firmware over the top. That's a little painful...

I agree that for development switching cards it is kinda awkward and I 
have been fooled by it as well. We may want to change or if your itch is 
annoying enough feel free to send a patch for it ;-)

Regards,
Arend


