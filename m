Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:60583 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003AbYJBShS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2008 14:37:18 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1272039rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 02 Oct 2008 11:37:17 -0700 (PDT)
Message-ID: <b6c5339f0810021137g3d93c5c8t5fa8fb3784294a86@mail.gmail.com> (sfid-20081002_203723_622500_1D8A5BEB)
Date: Thu, 2 Oct 2008 14:37:17 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Elias Oltmanns" <eo@nebensachen.de>
Subject: Re: [ath5k-devel] Oops with current kernel and ath5k
Cc: jirislaby@gmail.com, mickflemm@gmail.com,
	johannes@sipsolutions.net, toralf.foerster@gmx.de,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
In-Reply-To: <87bpy32c1w.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200808101401.03339.toralf.foerster@gmx.de>
	 <200810012055.58085.toralf.foerster@gmx.de>
	 <87ej30m376.fsf@denkblock.local>
	 <b6c5339f0810011515n770fa89bs3d09c16411121c79@mail.gmail.com>
	 <87ljx8ndw1.fsf@denkblock.local>
	 <b6c5339f0810011904h1208aa1dr197580780896197d@mail.gmail.com>
	 <87od23mo08.fsf@denkblock.local>
	 <b6c5339f0810020552m7b745a0fr336ae7b245b3b899@mail.gmail.com>
	 <20081002144600.M31352@bobcopeland.com>
	 <87bpy32c1w.fsf@denkblock.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 2, 2008 at 12:31 PM, Elias Oltmanns <eo@nebensachen.de> wrote:
> Sorry, but I don't think this is safe. Checking and restoring the
> started flag has to be protected too, otherwise there can be races
> against ->stop().

Yes, it's a bit of a mess.  Even if it were serialized, a ->stop()
happening between suspend's call to hw_stop and actually powering down
the device would clear the flag.  Ho hum.

-- 
Bob Copeland %% www.bobcopeland.com
