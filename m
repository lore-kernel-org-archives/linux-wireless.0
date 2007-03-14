Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:57261
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbXCNPiG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2007 11:38:06 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re:
Date: Wed, 14 Mar 2007 16:37:01 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <45f81577.+/XXKWDXwOzyP+DA%Larry.Finger@lwfinger.net>
In-Reply-To: <45f81577.+/XXKWDXwOzyP+DA%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703141637.02089.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 14 March 2007 16:32, Larry Finger wrote:
> During testing of bcm43xx interference mitigation, two problems were
> discovered:
> 
> (1) When the MANUALWLAN mode was set, routines _stack_save and _stack_restore
>     generated assertions that were traced to saving ILT registers with addresses
>     > 0xFFF. This problem was fixed by adding one bit to the field used for
>     the offset, and subtracting one bit from the space used for the id.
> (2) In MANUALWLAN mode, the IRQ XMIT errors are generated. The cause of these
>     errors has not yet been located. Any suggestions on debugging this problem
>     would be greatly appreciated.

Interference mitigation code is broken and has always been. It never worked.
So no wonder it doesn't work now. ;)
I'd suggest to first fix that (by a rewrite) before you do any code
that's based on it (like this ACI stuff).

I won't do it. interf mitigation is an uninterresting feature to me.

-- 
Greetings Michael.
