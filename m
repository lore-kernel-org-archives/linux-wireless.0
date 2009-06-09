Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57070 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbZFITPh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 15:15:37 -0400
Date: Tue, 9 Jun 2009 15:00:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Tobias Doerffel <tobias.doerffel@gmail.com>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: added cfg80211 based rfkill support
Message-ID: <20090609190026.GA3910@tuxdriver.com>
References: <20090607150755.GA19635@hash.localnet> <1244561607-6304-1-git-send-email-tobias.doerffel@gmail.com> <b6c5339f0906091126k573b8725hf623367abcdcdf1f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <b6c5339f0906091126k573b8725hf623367abcdcdf1f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 09, 2009 at 02:26:12PM -0400, Bob Copeland wrote:
> On Tue, Jun 9, 2009 at 11:33 AM, Tobias
> Doerffel<tobias.doerffel@gmail.com> wrote:
> 
> > +config ATH5K_RFKILL
> > +       bool "Atheros 5xxx rfkill support"
> > +       depends on ATH5K
> > +       default y
> > +       ---help---
> > +         Include support for enabling/disabling WiFi via rfkill switch
> > +         with Atheros 5xxx cards
> > +
> 
> We can still drop this.
> 
> > +       /* enable interrupt for rfkill switch */
> > +       if (AR5K_EEPROM_HDR_RFKILL(ah->ah_capabilities.cap_eeprom.ee_header)) {
> > +               ath5k_rfkill_set_intr(sc, true);
> > +       }
> 
> Coding style...
> 
> > +       if (AR5K_EEPROM_HDR_RFKILL(ah->ah_capabilities.cap_eeprom.ee_header)) {
> > +               ath5k_rfkill_set_intr(sc, false);
> > +       }
> 
> Ditto..
> 
> > +       /* enable RFKILL when stopping HW so Wifi LED is turned off */
> > +       ath5k_rfkill_enable(sc);
> 
> Odd, but ok :)
> 
> This looks really close and the remaining changes are pretty small.  If
> you want, I can take care of the above and resubmit it with your s-o-b
> so you don't have to go through another respin.

If that is your offer, maybe you could just do your own patch on top?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
