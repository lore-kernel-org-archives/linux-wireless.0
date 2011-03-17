Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:33761 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148Ab1CQWV4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 18:21:56 -0400
Message-ID: <4D82897C.8090204@free.fr>
Date: Thu, 17 Mar 2011 23:21:48 +0100
From: Le Gluon du Net <legluondunet@free.fr>
MIME-Version: 1.0
To: Daniel Halperin <dhalperi@cs.washington.edu>
CC: linux-wireless@vger.kernel.org
Subject: Re: can not compile ath9k driver for ubuntu 2.6.38-6-generic kernel
References: <4D8104FE.4030700@free.fr> <AANLkTikfR+hr6O+vjqRBsJ5e5sN4xC00sjUhHaBXBwu1@mail.gmail.com>
In-Reply-To: <AANLkTikfR+hr6O+vjqRBsJ5e5sN4xC00sjUhHaBXBwu1@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel, I followed your advice, I added:

#include <linux/sched.h>

in compat/compat-2.6.39.c

and ath9k compiles without problem.

Thank you very much.

LGDN

Le 16/03/2011 19:50, Daniel Halperin a écrit :
> On Wed, Mar 16, 2011 at 11:44 AM, Le Gluon du Net <legluondunet@free.fr> wrote:
>> /home/legluondunet/Bureau/compat-wireless-2011-03-15/compat/compat-2.6.39.c:
>> In function ‘tty_set_termios’:
>> /home/legluondunet/Bureau/compat-wireless-2011-03-15/compat/compat-2.6.39.c:93:4:
>> error: ‘TASK_INTERRUPTIBLE’ undeclared (first use in this function)
>> /home/legluondunet/Bureau/compat-wireless-2011-03-15/compat/compat-2.6.39.c:93:4:
>> note: each undeclared identifier is reported only once for each function
> This looks like the same problem that cropped up on iwlwifi 32-bit
> last week.  That file is probably missing an include for linux/sched.h
>
>
> Dan
>
