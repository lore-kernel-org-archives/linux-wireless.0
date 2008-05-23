Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:3337 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbYEWOLr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 10:11:47 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH] libertas: fix compact flash interrupt handling
Date: Fri, 23 May 2008 16:11:29 +0200
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
References: <200805231010.48939.hs4233@mail.mn-solutions.de> <200805231327.26652.hs4233@mail.mn-solutions.de>
In-Reply-To: <200805231327.26652.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805231611.29866.hs4233@mail.mn-solutions.de> (sfid-20080523_161158_428541_CF4E7B0E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hmm, I'm not sure if I found a regression with this patch, so
> hold it for now. I also think that splitting this patch into
> two should also be done.

Okay, I think the regression I saw was not because of this patch, 
but because of the issue I described as "BUG: getting erranesous 
command timeouts". I dunny why this bug didn't show up in 
rc2-wl, but now in rc3-wl. Maybe it has to do with the big 
kernel lock work that happens upstream, but that's just a guess.

However, I've splitted this patch into a functional part (the 
changed interrupt handling) and a search-and-replace part (the 
renaming & reorganizing of various #define's). Now it's easier 
to see what is happening.
