Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2503 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbYJGNG3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 09:06:29 -0400
Date: Tue, 7 Oct 2008 09:06:13 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: jirislaby@gmail.com, toralf.foerster@gmx.de,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com
Subject: Re: [ath5k-devel] Oops with current kernel and ath5k
Message-ID: <20081007130613.GB10693@hash.localnet> (sfid-20081007_150632_479016_F24B5C4A)
References: <b6c5339f0810020552m7b745a0fr336ae7b245b3b899@mail.gmail.com> <20081002144600.M31352@bobcopeland.com> <87bpy32c1w.fsf@denkblock.local> <b6c5339f0810021137g3d93c5c8t5fa8fb3784294a86@mail.gmail.com> <20081003134648.M45120@bobcopeland.com> <87fxnd2112.fsf@denkblock.local> <20081003193739.M19356@bobcopeland.com> <877i8nky65.fsf@denkblock.local> <20081007013529.GA9691@hash.localnet> <873aj8vg45.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <873aj8vg45.fsf@denkblock.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct
Not sure 07, 2008 at 12:44:58PM +0200, Elias Oltmanns wrote:
> Looking through the code, I'm wondering about the atomicity requirements
> of sc->status. In my opinion, __set_bit() is not permissible in various
> places (including your use case). But since this is a problem that has
> been around before, I will send a separate patch once yours has been
> merged.

Ok, I don't see why it's a problem in this case, but I'll look for 
your patch.  Note we should be doing sc->status updates under a mutex
already; if not that's a bug.

-- 
Bob Copeland %% www.bobcopeland.com

