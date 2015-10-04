Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from limerock01.mail.cornell.edu ([128.84.13.241]:40162 "EHLO
	limerock01.mail.cornell.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751525AbbJDTlh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 15:41:37 -0400
Date: Sun, 4 Oct 2015 15:26:18 -0400
From: Jacob Kiefer <jtk54@cornell.edu>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Gujulan Elango, Hari Prasath (H.)" <hgujulan@visteon.com>,
	Roberta Dobrescu <roberta.dobrescu@gmail.com>,
	"open list:STAGING - REALTEK RTL8723U WIRELESS DRIVER"
	<linux-wireless@vger.kernel.org>,
	"open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: rtl8723au: Fix Sparse errors in rtl8723a_cmd.c
Message-ID: <20151004192618.GA2938@jtk54-Q550LF> (sfid-20151004_214202_313861_4EA2EAC3)
References: <1443832594-29663-1-git-send-email-jtk54@cornell.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1443832594-29663-1-git-send-email-jtk54@cornell.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

Thanks for the response! It's always good to get notes on a patch.
Some responses to your points:

> Why __le32?  Does this variable go across the user/kernel boundry
> somehow?  If not, just use le32.

Good point, this should probably have been le32.

> At first glance, you aren't doing ths same logic in this function as the
> original did, please look at this very closely again and verify that you
> are doing this correctly.
>
> Don't just blindly quiet tools like sparse, it is warning for a reason,
> but be careful about your fix.

On a second, closer look at the code I am not doing this correctly: the
buffer I am converting to le32 needs to persist (which a local variable
would not). On my first glance at this code I saw the same buffer being
used for both little- and big-endian storage of the same data -- it's
correct, but a little ugly.

I am going to leave this code as is, since it was functioning properly
before my patch.

Thanks,
Jake
