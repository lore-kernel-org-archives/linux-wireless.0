Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:63750 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbYHCN0q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 09:26:46 -0400
Received: by nf-out-0910.google.com with SMTP id d3so601816nfc.21
        for <linux-wireless@vger.kernel.org>; Sun, 03 Aug 2008 06:26:44 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 5/8] rfkill: add WARN_ON and BUG_ON paranoia
Date: Sun, 3 Aug 2008 15:50:06 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br> <1217753845.4721.1.camel@johannes.berg> <20080803132103.GB12118@khazad-dum.debian.net>
In-Reply-To: <20080803132103.GB12118@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808031550.06747.IvDoorn@gmail.com> (sfid-20080803_152649_109459_4E7989EF)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 03 August 2008, Henrique de Moraes Holschuh wrote:
> On Sun, 03 Aug 2008, Johannes Berg wrote:
> > if (WARN_ON(!nb))
> > 	return -EINVAL;
> 
> I could use the notation above instead of:
> if (foo) {
> 	WARN_ON(1);
> 	return -ERROR;
> }
> 
> Ivo, which one you prefer?  The if() with the condition and WARN on the
> branch, or the if(WARN_ON(condition)) ?

Well my preference is either:

	if (WARN_ON(!nb))
		return -EINVAL;

or

	if (foo) {
		WARN();
		return -EINVAL;
	}

Doesn't really matter which of those 2. But like I said in the other patch,
WARN_ON(1) sounds just ugly. ;)

> > BUG() never returns. Same for all the other places you pointed out.
> 
> Yes.  And I used BUG() on the notify chain calls, because the primitives in
> the kernel code are not doing proper error checking anyway (for speed, I
> suppose)...  they just OOPS.

Ok, if for the notify chain BUG() is standard you can use that there. But the
others are preferably WARN(). :)

Ivo
