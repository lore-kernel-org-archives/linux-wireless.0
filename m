Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:3929 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbYEMJpA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 05:45:00 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2668128wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 13 May 2008 02:45:00 -0700 (PDT)
Message-ID: <f6ca9fed0805130244x648325a3k2ae7b77fa610ca6d@mail.gmail.com> (sfid-20080513_114514_369567_77E65C9D)
Date: Tue, 13 May 2008 11:44:59 +0200
From: drago01 <drago01@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: dynamic wep with mulitple keys
Cc: "Tomas Winkler" <tomasw@gmail.com>,
	"Emmanuel Grumbach" <egrumbach@gmail.com>,
	"Volker Braun" <vbraun@physics.upenn.edu>,
	"Linux Wireless" <linux-wireless@vger.kernel.org>
In-Reply-To: <1210670668.3646.56.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1208969544.3312.5.camel@localhost.localdomain>
	 <8704f27d0805060032g2312e7dcwc19f382c431e6cd3@mail.gmail.com>
	 <f6ca9fed0805060510l36c72666v414dfd989625d18e@mail.gmail.com>
	 <8704f27d0805060514i59db36f0t9801fab7543b8655@mail.gmail.com>
	 <f6ca9fed0805120447wf6c1c38mea24ba587dc834d4@mail.gmail.com>
	 <1ba2fa240805120507r2914d23dt6826a732730fea49@mail.gmail.com>
	 <f6ca9fed0805120510yec6ba9fge41c46d2d01c236a@mail.gmail.com>
	 <1ba2fa240805120522m26904f72l45941b1beb411e60@mail.gmail.com>
	 <f6ca9fed0805120538k75a953acrc1cd251efe9bbe1b@mail.gmail.com>
	 <1210670668.3646.56.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 13, 2008 at 11:24 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>  > >  SW crypto is handled by mac80211 so I ponder why it works above 4965
>  > >  and not over 3945 but it has nothing to do with this particular change
>  >
>  > OK, Johannes any idea why this happens?
>
>  I don't even know what happens :)

he ok.

The problem is that when connecting to a dynamic wep network which
uses multiple keys iwl3945 fails to get a dhcp lease. (See
http://marc.info/?l=linux-wireless&m=120699235803881&w=2)
Volker had the same problem with iwl4965.  But when turning off
hwcrypto and therefore use the mac80211 code it works for him.
iwl3945 does not use hwcrypto by default (and when I enable it it does
not work either) but fails. Both should be using the same code
(mac80211) but one driver works and the other doesn't which is odd.
