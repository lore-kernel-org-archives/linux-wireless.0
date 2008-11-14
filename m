Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2505 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbYKNNS7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 08:18:59 -0500
Date: Fri, 14 Nov 2008 08:18:24 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Dan McGee <dpmcgee@gmail.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@gmail.com
Subject: Re: Kernel oops when loading ath5k from compat-wireless in 2.6.27
Message-ID: <20081114131824.GA10586@hash.localnet> (sfid-20081114_141905_301861_457B7A49)
References: <449c10960811132146s40aef6c6ue8dfeef5ba29812a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <449c10960811132146s40aef6c6ue8dfeef5ba29812a@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 13, 2008 at 11:46:06PM -0600, Dan McGee wrote:
> 
> GDB disassembly:
> 
> 0x000002cc <ieee80211_register_hw+357>: sbb    %eax,%eax
> 0x000002ce <ieee80211_register_hw+359>: and    $0x100,%edx
> 0x000002d4 <ieee80211_register_hw+365>: and    $0xf,%al
> 0x000002d6 <ieee80211_register_hw+367>: inc    %al
> ^^^ HERE ^^^

I don't think this disassembly is right.  inc %al is not a very likely 
faulting instruction, especially if we just did a successful AND on the
register.  Luis' suggestion to use gdb to directly list the C code is 
good; here's another way:

Run scripts/decodecode on the "Code: ...." portion (output below).
There you can see that the faulting instruction is actually 
"mov (%eax), %eax" which makes sense because %eax in the register dump
is zero, so it's clearly a null pointer dereference.  We're
dereferencing some pointer at offset 0xbc in some structure.

Now you can do objdump -S net/mac80211/main.o to see mixed C and
assembly, and look for a segment of code that matches your disassembly.  
Sometimes that can be a bit confusing with inlines and code scheduling, 
but that's the nature of the beast.

(I haven't had a chance to look at the actual code yet.)

Disassembly of section .text:

00000000 <.text>:
   0:	83 c8 00             	or     $0x0,%eax
   3:	00 00                	add    %al,(%eax)
   5:	21 03                	and    %eax,(%ebx)
   7:	c7 83 b4 00 00 00 1c 	movl   $0xb80d491c,0xb4(%ebx)
   e:	49 0d b8 
  11:	c7 83 0c 02 00 00 ee 	movl   $0xb80c17ee,0x20c(%ebx)
  18:	17 0c b8 
  1b:	8b 46 1c             	mov    0x1c(%esi),%eax
  1e:	8b 40 7c             	mov    0x7c(%eax),%eax
  21:	8b 80 bc 00 00 00    	mov    0xbc(%eax),%eax
  27:	6a 00                	push   $0x0
  29:	6a 00                	push   $0x0
   0:	8b 00                	mov    (%eax),%eax      <--- HERE
   2:	e8 75 64 06 c0       	call   0xc006647c
   7:	5f                   	pop    %edi
   8:	bf f4 ff ff ff       	mov    $0xfffffff4,%edi
   d:	85 c0                	test   %eax,%eax
   f:	89 46 20             	mov    %eax,0x20(%esi)
  12:	5a                   	pop    %edx
  13:	0f                   	.byte 0xf
  14:	84                   	.byte 0x84

-- 
Bob Copeland %% www.bobcopeland.com

