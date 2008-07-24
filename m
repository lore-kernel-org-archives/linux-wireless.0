Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:53417 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbYGXVkH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 17:40:07 -0400
Subject: Re: [PATCH 2/12] ath5k: Restore saved initval after POST
From: Pavel Roskin <proski@gnu.org>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Nick Kossifidis <mick@madwifi.org>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	jirislaby@gmail.com, mcgrof@gmail.com
In-Reply-To: <40f31dec0807241436v4d3c217bne359a5230143d1a3@mail.gmail.com>
References: <20080720033232.GB7440@makis> <1216934788.3094.8.camel@dv>
	 <40f31dec0807241436v4d3c217bne359a5230143d1a3@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 24 Jul 2008 17:40:05 -0400
Message-Id: <1216935605.3094.18.camel@dv> (sfid-20080724_234010_343491_CB64E958)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-07-25 at 00:36 +0300, Nick Kossifidis wrote:
> 2008/7/25 Pavel Roskin <proski@gnu.org>:
> > On Sun, 2008-07-20 at 06:32 +0300, Nick Kossifidis wrote:
> >> * Restore saved initial value after POST
> > ...
> >> @@ -170,6 +172,10 @@ static int ath5k_hw_post(struct ath5k_hw *ah)
> >>                       var_pattern = 0x003b080f;
> >>                       ath5k_hw_reg_write(ah, var_pattern, cur_reg);
> >>               }
> >> +
> >> +             /* Restore previous value */
> >> +             ath5k_hw_reg_write(ah, init_val, cur_reg);
> >> +
> >>       }
> >
> > Perhaps "at the end of POST"?  Anyway, the code looks good to me.
> >
> 
> We are not restoring at the end of POST but after we end with each of
> the two registers, so i guess it's ok this way

OK, fine with me.

-- 
Regards,
Pavel Roskin
