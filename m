Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43686 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab2G2Mb3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jul 2012 08:31:29 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1SvSed-0008LL-LB
	for linux-wireless@vger.kernel.org; Sun, 29 Jul 2012 14:31:27 +0200
Received: from 81-57.bbned.dsl.internl.net ([92.254.57.81])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 29 Jul 2012 14:31:27 +0200
Received: from Mijzelf by 81-57.bbned.dsl.internl.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 29 Jul 2012 14:31:27 +0200
To: linux-wireless@vger.kernel.org
From: Mijzelf <Mijzelf@live.com>
Subject: Re: Uknown symbols in =?utf-8?b?cmZraWxsX2JhY2twb3J0Lmtv?= on 2.6.25.17 on mips
Date: Sun, 29 Jul 2012 12:31:16 +0000 (UTC)
Message-ID: <loom.20120729T135851-141@post.gmane.org> (sfid-20120729_143133_239636_C07C97D6)
References: <0621389a37a568a7ebd526b0adc87a48@fileserver.lan> <20120724175617.0a4206c4@mj> <loom.20120725T195215-756@post.gmane.org> <20120726172555.246a668c@mj>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin <proski@...> writes:
> 
> My guess is that either it's a result of some clever macro expansion
> (so that the source doesn't have "flush_cache") or gcc inserts that call
> (perhaps hoping that libgcc has it) but the kernel doesn't satisfy it.
> 
> First of all, make sure that you are making a clean build and there are
> no object files left from older builds.
> 
> Then find the object file that calls _flush_cache.  Recompile the
> corresponding source file with "-save-temps".  Look for "flush_cache"
> in the *.i and the *.s file.  Try to find out where it comes from.
> 
There are several objects which call _flush_cache, mesh_pathtbl, mac80211, agg-
tx, work and cfg. Looking at the .i and .s files I found that by far the least 
complex function was free_work() in work.c:

void free_work(struct ieee80211_work *wk)
{
        kfree_rcu(wk, rcu_head);
}

work.i:

void free_work(struct ieee80211_work *wk)
{
 do { void __kfree_rcu_fn(struct rcu_head *rcu_head) { void *___ptr; ___ptr = 
({ const typeof( ((typeof(*(wk)) *)0)->rcu_head
 ) *__mptr = (rcu_head); (typeof(*(wk)) *)( (char *)__mptr - ((size_t) &((typeof
(*(wk)) *)0)->rcu_head) );}); kfree(___ptr);
} call_rcu(&(wk)->rcu_head, __kfree_rcu_fn); } while (0);
}

work.s:

$LTRAMP0:
        .word   0x03e00821              # move   $1,$31
        .word   0x04110001              # bgezal $0,.+8
        .word   0x00000000              # nop
        .word   0x8fe30014              # lw     $3,20($31)
        .word   0x8fe20018              # lw     $2,24($31)
        .word   0x0060c821              # move   $25,$3 (abicalls)
        .word   0x00600008              # jr     $3
        .word   0x0020f821              # move   $31,$1
        .word   0x00000000              # <function address>
        .word   0x00000000              # <static chain value>
        .globl  _flush_cache
        .text
        .align  2
        .globl  free_work
        .ent    free_work
        .type   free_work, @function
free_work:
        .frame  $sp,80,$31              # vars= 48, regs= 3/0, args= 16, gp= 0
        .mask   0x80030000,-8
        .fmask  0x00000000,0
        .set    noreorder
        .set    nomacro
        
        addiu   $sp,$sp,-80
        sw      $16,64($sp)
        lui     $5,%hi($LTRAMP0)
        addiu   $16,$sp,16
        lui     $2,%hi(memcpy)
        sw      $31,72($sp)
        sw      $17,68($sp)
        addiu   $5,$5,%lo($LTRAMP0)
        move    $17,$4
        li      $6,40                   # 0x28
        addiu   $2,$2,%lo(memcpy)
        jal     $2
        move    $4,$16

        lui     $2,%hi(__kfree_rcu_fn.0)
        addiu   $2,$2,%lo(__kfree_rcu_fn.0)
        addiu   $3,$sp,16
        sw      $2,32($16)
        lui     $2,%hi(_flush_cache)
        move    $4,$16
        sw      $3,36($16)
        li      $5,40                   # 0x28
        addiu   $2,$2,%lo(_flush_cache)
        jal     $2
<snip>

Looking at this it seems to me it must be some compiler-inserted memory 
barrier, or something like that. But that memcpy baffles me.

I think I'll just add a dummy _flush_cache. My target system is single core, I 
suppose it would be safe.




