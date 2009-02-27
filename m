Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4552 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbZB0DGt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2009 22:06:49 -0500
Date: Thu, 26 Feb 2009 22:06:08 -0500
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	"proski@gnu.org" <proski@gnu.org>,
	"ath5k-devel@venema.h4ckr.net" <ath5k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: fix hw rate index condition
Message-ID: <20090227030608.GA29974@hash.localnet> (sfid-20090227_040711_000471_E8B56A17)
References: <1235688271-22346-1-git-send-email-jirislaby@gmail.com> <20090226230338.M86894@bobcopeland.com> <49A7236E.2020807@gmail.com> <b6c5339f0902261528i7b581125k29927c3c5ac4fe4c@mail.gmail.com> <49A726A7.6090809@gmail.com> <20090227022704.GA29850@hash.localnet> <20090227023912.GF13456@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090227023912.GF13456@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 26, 2009 at 06:39:12PM -0800, Luis R. Rodriguez wrote:
> Might be worth adding a note why this is the case. Can't we simply avoid
> this by checking earlier for the error or simply assigning it an actual
> default _good_ hw rate value?

I guess an alternative is to initialize to 0, that would count any rx
packets whose hw rate we don't know about as the base rate, so it would
probably bias the RC to 1mb, but this is already one of those 'should 
never happen' cases.  Also I can't forsee having a rate index > 127 so
changing the sign is pretty low risk.

-- 
Bob Copeland %% www.bobcopeland.com

