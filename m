Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:63557 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbYGWRvq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 13:51:46 -0400
Received: by nf-out-0910.google.com with SMTP id d3so923906nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 10:51:44 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [GIT PATCH] RFC: next batch of rfkill changes
Date: Wed, 23 Jul 2008 20:08:59 +0200
Cc: linux-wireless@vger.kernel.org
References: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807232008.59241.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 23 July 2008, Henrique de Moraes Holschuh wrote:
> 
> This is my next batch of rfkill changes.  They add features and address
> some shortcomings of rfkill-input, mostly.
> 
> Please comment.  One thing that is bothering me in the last patch is
> what happens during suspend/resume to pending delayed rfkill state
> changes.  Are pending scheduled jobs executed, cancelled, or frozen to
> fire up when the system resumes itself?

When using the kernel workqueue, I *think* they are frozen until the system
resumes. When using a private workqueue you should use the freezable
workqueue allocation.

But in this case you are using the kernel workqueue, so I assume it is
scheduled untill after resume.

> Henrique de Moraes Holschuh (6):
>       rfkill: detect bogus double-registering
>       rfkill: add default global states
>       rfkill: add master_switch_mode functionality
>       rfkill: add EPO lock to rfkill-input
>       rfkill: rename rfkill_mutex to rfkill_global_mutex
>       rfkill: rate-limit rfkill-input workqueue usage
> 

Ivo
