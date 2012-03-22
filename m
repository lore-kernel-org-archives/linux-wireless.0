Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm2.bullet.mail.ukl.yahoo.com ([217.146.183.219]:43721 "HELO
	nm2.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754716Ab2CVTf7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Mar 2012 15:35:59 -0400
From: Marek Lindner <lindner_marek@yahoo.de>
To: Javier Cardona <javier@cozybit.com>
Subject: Re: [PATCH v2] mac80211: fix the RANN propagation issues
Date: Thu, 22 Mar 2012 20:35:49 +0100
Cc: "Chun-Yeow Yeoh" <yeohchunyeow@gmail.com>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	thomas@cozybit.com, linville@tuxdriver.com,
	devel@lists.open80211s.org
References: <1332420968-16300-1-git-send-email-yeohchunyeow@gmail.com> <201203221958.10427.lindner_marek@yahoo.de> <CAPjQAd-j0mP9faqSkwuDWErX1v+dbzYqO+rL6sKN-2ZMYr_FGA@mail.gmail.com>
In-Reply-To: <CAPjQAd-j0mP9faqSkwuDWErX1v+dbzYqO+rL6sKN-2ZMYr_FGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201203222035.50568.lindner_marek@yahoo.de> (sfid-20120322_203603_954421_FFFC0679)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, March 22, 2012 20:13:28 Javier Cardona wrote:
> On Thu, Mar 22, 2012 at 11:58 AM, Marek Lindner <lindner_marek@yahoo.de> 
wrote:
> > On Thursday, March 22, 2012 17:31:33 Javier Cardona wrote:
> >> >>  #define SN_GT(x, y) ((long) (y) - (long) (x) < 0)
> >> >>  #define SN_LT(x, y) ((long) (x) - (long) (y) < 0)
> >> > 
> >> > Your macros tried to address the problem but casting your sequence
> >> > number to long also breaks the wrap around.
> >> 
> >> Ah, thanks for your help.  I guess we do need those macros after all
> >> but they'd have to be re-written as
> >> 
> >> #define SN_LT(x, y) ((s32)(x - y) < 0)
> >> #define SN_GT(x, y) ((s32)(x - y) > 0)
> > 
> > No, you need unsigned values for this arithmetic to work (which is why
> > long also fails).
> 
> The macro is always used on u32 values, so the arithmetic would be
> unsigned in this case.

Ok - then you should be on the safe side.

Regards,
Marek
