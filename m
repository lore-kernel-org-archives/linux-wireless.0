Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:51211 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754714AbYHCNVI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 09:21:08 -0400
Date: Sun, 3 Aug 2008 10:21:03 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/8] rfkill: add WARN_ON and BUG_ON paranoia
Message-ID: <20080803132103.GB12118@khazad-dum.debian.net> (sfid-20080803_152141_090263_D1AFB303)
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br> <1217700664-20792-6-git-send-email-hmh@hmh.eng.br> <200808031007.48877.IvDoorn@gmail.com> <1217753845.4721.1.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1217753845.4721.1.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 03 Aug 2008, Johannes Berg wrote:
> if (WARN_ON(!nb))
> 	return -EINVAL;

I could use the notation above instead of:
if (foo) {
	WARN_ON(1);
	return -ERROR;
}

Ivo, which one you prefer?  The if() with the condition and WARN on the
branch, or the if(WARN_ON(condition)) ?

> BUG() never returns. Same for all the other places you pointed out.

Yes.  And I used BUG() on the notify chain calls, because the primitives in
the kernel code are not doing proper error checking anyway (for speed, I
suppose)...  they just OOPS.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
