Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from outbound1a.ore.mailhop.org ([54.213.22.21]:12623 "EHLO
        outbound1a.ore.mailhop.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753438AbcKWVPZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 16:15:25 -0500
Date: Wed, 23 Nov 2016 20:59:17 +0000
From: Jason Cooper <jason@lakedaemon.net>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: linux-wireless@vger.kernel.org,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        ath9k-devel@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Kalle Valo <kvalo@codeaurora.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: ath9k ARMv7 OOPS in v4.8.6, v4.2.8
Message-ID: <20161123205917.GI2799@io.lakedaemon.net> (sfid-20161123_221529_912661_A1D35137)
References: <20161123191539.GF2799@io.lakedaemon.net>
 <20161123195120.GE14217@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161123195120.GE14217@n2100.armlinux.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 23, 2016 at 07:51:20PM +0000, Russell King - ARM Linux wrote:
> On Wed, Nov 23, 2016 at 07:15:39PM +0000, Jason Cooper wrote:
> > ------- oops from v4.8.6 #2 ------------------------------------------
> > [42059.303625] Unable to handle kernel NULL pointer dereference at virtual address 00000020
> > [42059.311799] pgd = c0004000
> > [42059.314522] [00000020] *pgd=00000000
> > [42059.318162] Internal error: Oops: 17 [#1] SMP ARM
> > [42059.322889] Modules linked in: ath9k ath9k_common ath9k_hw ath
> > [42059.328809] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.8.6 #37
> > [42059.334755] Hardware name: Marvell Armada 370/XP (Device Tree)
> > [42059.340613] task: c0b091c0 task.stack: c0b00000
> > [42059.345176] PC is at ath_cmn_process_fft+0xa0/0x578 [ath9k_common]
> > [42059.351388] LR is at ath_cmn_process_fft+0xc4/0x578 [ath9k_common]
> > [42059.357598] pc : [<bf07bec4>]    lr : [<bf07bee8>]    psr: 80000153
> > [42059.357598] sp : c0b01cd0  ip : 00000000  fp : 00000000
> > [42059.369127] r10: c0b034d4  r9 : 00000069  r8 : 0000006c
> > [42059.374374] r7 : 00000000  r6 : dcfbd340  r5 : c0b03da0  r4 : 00000000
> > [42059.380930] r3 : 00000001  r2 : 00000008  r1 : 00000004  r0 : 00000000
> 
> Well, the good news is that it's reproducable.
> 
> It looks like it could be this:
> 
> static int
> ath_cmn_is_fft_buf_full(struct ath_spec_scan_priv *spec_priv)
> {
>         for_each_online_cpu(i)
>                 ret += relay_buf_full(rc->buf[i]);
> 
> where i = 8 (r2) and rc->buf is r7.  That's just a guess though, as
> there's precious little to go on with the Code: line - modern GCCs
> don't give us much with the Code: line anymore to figure out what's
> going on without the exact object files.
> 
>         e5933000        ldr     r3, [r3]
>         e1d330b4        ldrh    r3, [r3, #4]
>         e58d3030        str     r3, [sp, #48]   ; 0x30
>         ea000002        b       1c <foo+0x1c>
>         e7970102        ldr     r0, [r7, r2, lsl #2]
> 

As requested on irc:


-------------->8--------------------------------------------------------
drivers/net/wireless/ath/ath9k/common-spectral.o:     file format elf32-littlearm


Disassembly of section .text:

...

00000754 <ath_cmn_process_fft>:
     754:	e92d4ff0 	push	{r4, r5, r6, r7, r8, r9, sl, fp, lr}
     758:	e24dd0d4 	sub	sp, sp, #212	; 0xd4
     75c:	e1a04002 	mov	r4, r2
     760:	e1a06001 	mov	r6, r1
     764:	e58d0024 	str	r0, [sp, #36]	; 0x24
     768:	e3a01000 	mov	r1, #0
     76c:	e58d2018 	str	r2, [sp, #24]
     770:	e28d0049 	add	r0, sp, #73	; 0x49
     774:	e3a02087 	mov	r2, #135	; 0x87
     778:	ebfffffe 	bl	0 <memset>
     77c:	e5d44007 	ldrb	r4, [r4, #7]
     780:	e20430fd 	and	r3, r4, #253	; 0xfd
     784:	e3530024 	cmp	r3, #36	; 0x24
     788:	13540005 	cmpne	r4, #5
     78c:	13a04001 	movne	r4, #1
     790:	03a04000 	moveq	r4, #0
     794:	13a00000 	movne	r0, #0
     798:	0a000001 	beq	7a4 <ath_cmn_process_fft+0x50>
     79c:	e28dd0d4 	add	sp, sp, #212	; 0xd4
     7a0:	e8bd8ff0 	pop	{r4, r5, r6, r7, r8, r9, sl, fp, pc}
     7a4:	e59d3018 	ldr	r3, [sp, #24]
     7a8:	e1d380b4 	ldrh	r8, [r3, #4]
     7ac:	e2489003 	sub	r9, r8, #3
     7b0:	e0863009 	add	r3, r6, r9
     7b4:	e5d30002 	ldrb	r0, [r3, #2]
     7b8:	e2000010 	and	r0, r0, #16
     7bc:	e21000ff 	ands	r0, r0, #255	; 0xff
     7c0:	0afffff5 	beq	79c <ath_cmn_process_fft+0x48>
     7c4:	e59d3024 	ldr	r3, [sp, #36]	; 0x24
     7c8:	e3005000 	movw	r5, #0
     7cc:	e3405000 	movt	r5, #0
     7d0:	e3e0b000 	mvn	fp, #0
     7d4:	e5932000 	ldr	r2, [r3]
     7d8:	e5937004 	ldr	r7, [r3, #4]
     7dc:	e5923438 	ldr	r3, [r2, #1080]	; 0x438
     7e0:	e58d2010 	str	r2, [sp, #16]
     7e4:	e5933000 	ldr	r3, [r3]
     7e8:	e1d330b4 	ldrh	r3, [r3, #4]
     7ec:	e58d3030 	str	r3, [sp, #48]	; 0x30
     7f0:	ea000002 	b	800 <ath_cmn_process_fft+0xac>
     7f4:	e7970102 	ldr	r0, [r7, r2, lsl #2]
     7f8:	ebfffffe 	bl	0 <relay_buf_full>
     7fc:	e0844000 	add	r4, r4, r0
     800:	e300a000 	movw	sl, #0
     804:	e28b2001 	add	r2, fp, #1
     808:	e340a000 	movt	sl, #0
     80c:	e3a01004 	mov	r1, #4
     810:	e1a0000a 	mov	r0, sl
     814:	ebfffffe 	bl	0 <_find_next_bit_le>
     818:	e5953000 	ldr	r3, [r5]
     81c:	e1500003 	cmp	r0, r3
     820:	e1a0b000 	mov	fp, r0
     824:	e2802008 	add	r2, r0, #8
     828:	bafffff1 	blt	7f4 <ath_cmn_process_fft+0xa0>
     82c:	e59a0000 	ldr	r0, [sl]
     830:	e200000f 	and	r0, r0, #15
     834:	ebfffffe 	bl	0 <__sw_hweight32>
     838:	e1540000 	cmp	r4, r0
     83c:	0a000092 	beq	a8c <ath_cmn_process_fft+0x338>
     840:	e59d3010 	ldr	r3, [sp, #16]
     844:	e5932030 	ldr	r2, [r3, #48]	; 0x30
     848:	e5923018 	ldr	r3, [r2, #24]
     84c:	e3530001 	cmp	r3, #1
     850:	0a000090 	beq	a98 <ath_cmn_process_fft+0x344>
     854:	3a000119 	bcc	cc0 <ath_cmn_process_fft+0x56c>
     858:	e3530002 	cmp	r3, #2
     85c:	1a000110 	bne	ca4 <ath_cmn_process_fft+0x550>
     860:	e3003000 	movw	r3, #0
     864:	e5921014 	ldr	r1, [r2, #20]
     868:	e1a00003 	mov	r0, r3
     86c:	e592301c 	ldr	r3, [r2, #28]
     870:	e3002000 	movw	r2, #0
     874:	e3a0b087 	mov	fp, #135	; 0x87
     878:	e1a0c002 	mov	ip, r2
     87c:	e1a02000 	mov	r2, r0
     880:	e3402000 	movt	r2, #0
     884:	e58d2034 	str	r2, [sp, #52]	; 0x34
     888:	e1a0200c 	mov	r2, ip
     88c:	e3a0a08a 	mov	sl, #138	; 0x8a
     890:	e3402000 	movt	r2, #0
     894:	e58d2044 	str	r2, [sp, #68]	; 0x44
     898:	e1d120b4 	ldrh	r2, [r1, #4]
     89c:	e3a01080 	mov	r1, #128	; 0x80
     8a0:	e58d1020 	str	r1, [sp, #32]
     8a4:	e1520003 	cmp	r2, r3
     8a8:	33a03003 	movcc	r3, #3
     8ac:	23a03002 	movcs	r3, #2
     8b0:	e58d3038 	str	r3, [sp, #56]	; 0x38
     8b4:	e2483002 	sub	r3, r8, #2
     8b8:	e58d3014 	str	r3, [sp, #20]
     8bc:	e3530000 	cmp	r3, #0
     8c0:	da000071 	ble	a8c <ath_cmn_process_fft+0x338>
     8c4:	e3a03000 	mov	r3, #0
     8c8:	e28aa002 	add	sl, sl, #2
     8cc:	e1a04003 	mov	r4, r3
     8d0:	e58d3028 	str	r3, [sp, #40]	; 0x28
     8d4:	e1a05004 	mov	r5, r4
     8d8:	e24b3001 	sub	r3, fp, #1
     8dc:	e1a07006 	mov	r7, r6
     8e0:	e58d302c 	str	r3, [sp, #44]	; 0x2c
     8e4:	e58db01c 	str	fp, [sp, #28]
     8e8:	e1a03009 	mov	r3, r9
     8ec:	e58d8010 	str	r8, [sp, #16]
     8f0:	e1a09004 	mov	r9, r4
     8f4:	ea00002c 	b	9ac <ath_cmn_process_fft+0x258>
     8f8:	e3520007 	cmp	r2, #7
     8fc:	e1a05003 	mov	r5, r3
     900:	e086b004 	add	fp, r6, r4
     904:	8a00006f 	bhi	ac8 <ath_cmn_process_fft+0x374>
     908:	e59d202c 	ldr	r2, [sp, #44]	; 0x2c
     90c:	e1530002 	cmp	r3, r2
     910:	a3a09001 	movge	r9, #1
     914:	ba0000dd 	blt	c90 <ath_cmn_process_fft+0x53c>
     918:	e59d101c 	ldr	r1, [sp, #28]
     91c:	e2812002 	add	r2, r1, #2
     920:	e1520005 	cmp	r2, r5
     924:	ba000058 	blt	a8c <ath_cmn_process_fft+0x338>
     928:	e1510005 	cmp	r1, r5
     92c:	aa000092 	bge	b7c <ath_cmn_process_fft+0x428>
     930:	e5d7001f 	ldrb	r0, [r7, #31]
     934:	e5d71020 	ldrb	r1, [r7, #32]
     938:	e1500001 	cmp	r0, r1
     93c:	1a000052 	bne	a8c <ath_cmn_process_fft+0x338>
     940:	e58d3040 	str	r3, [sp, #64]	; 0x40
     944:	e1a01004 	mov	r1, r4
     948:	e59d3044 	ldr	r3, [sp, #68]	; 0x44
     94c:	e1a0000b 	mov	r0, fp
     950:	e58d203c 	str	r2, [sp, #60]	; 0x3c
     954:	e12fff33 	blx	r3
     958:	e3500000 	cmp	r0, #0
     95c:	e59d203c 	ldr	r2, [sp, #60]	; 0x3c
     960:	e59d3040 	ldr	r3, [sp, #64]	; 0x40
     964:	1a00008e 	bne	ba4 <ath_cmn_process_fft+0x450>
     968:	e59d2010 	ldr	r2, [sp, #16]
     96c:	e152000a 	cmp	r2, sl
     970:	da0000c9 	ble	c9c <ath_cmn_process_fft+0x548>
     974:	e59d9028 	ldr	r9, [sp, #40]	; 0x28
     978:	e2842001 	add	r2, r4, #1
     97c:	e0867002 	add	r7, r6, r2
     980:	e3590000 	cmp	r9, #0
     984:	13a09000 	movne	r9, #0
     988:	1a000003 	bne	99c <ath_cmn_process_fft+0x248>
     98c:	e59d2020 	ldr	r2, [sp, #32]
     990:	e2425002 	sub	r5, r2, #2
     994:	e0844005 	add	r4, r4, r5
     998:	e2842001 	add	r2, r4, #1
     99c:	e1a04002 	mov	r4, r2
     9a0:	e59d2014 	ldr	r2, [sp, #20]
     9a4:	e1540002 	cmp	r4, r2
     9a8:	aa000037 	bge	a8c <ath_cmn_process_fft+0x338>
     9ac:	e59d2010 	ldr	r2, [sp, #16]
     9b0:	e152000a 	cmp	r2, sl
     9b4:	e7d62004 	ldrb	r2, [r6, r4]
     9b8:	daffffce 	ble	8f8 <ath_cmn_process_fft+0x1a4>
     9bc:	e3520007 	cmp	r2, #7
     9c0:	e2855001 	add	r5, r5, #1
     9c4:	e086b004 	add	fp, r6, r4
     9c8:	8a000002 	bhi	9d8 <ath_cmn_process_fft+0x284>
     9cc:	e59d202c 	ldr	r2, [sp, #44]	; 0x2c
     9d0:	e1550002 	cmp	r5, r2
     9d4:	aaffffcf 	bge	918 <ath_cmn_process_fft+0x1c4>
     9d8:	e3590000 	cmp	r9, #0
     9dc:	0affffed 	beq	998 <ath_cmn_process_fft+0x244>
     9e0:	e59d201c 	ldr	r2, [sp, #28]
     9e4:	e1520005 	cmp	r2, r5
     9e8:	1affffe1 	bne	974 <ath_cmn_process_fft+0x220>
     9ec:	ea00007e 	b	bec <ath_cmn_process_fft+0x498>
     9f0:	e597e000 	ldr	lr, [r7]
     9f4:	e24b201f 	sub	r2, fp, #31
     9f8:	e597c004 	ldr	ip, [r7, #4]
     9fc:	e2871021 	add	r1, r7, #33	; 0x21
     a00:	e5973008 	ldr	r3, [r7, #8]
     a04:	e28d0068 	add	r0, sp, #104	; 0x68
     a08:	e58de049 	str	lr, [sp, #73]	; 0x49
     a0c:	e58dc04d 	str	ip, [sp, #77]	; 0x4d
     a10:	e597e010 	ldr	lr, [r7, #16]
     a14:	e597c014 	ldr	ip, [r7, #20]
     a18:	e58d3051 	str	r3, [sp, #81]	; 0x51
     a1c:	e597300c 	ldr	r3, [r7, #12]
     a20:	e58de059 	str	lr, [sp, #89]	; 0x59
     a24:	e58dc05d 	str	ip, [sp, #93]	; 0x5d
     a28:	e58d3055 	str	r3, [sp, #85]	; 0x55
     a2c:	e1d7c1bc 	ldrh	ip, [r7, #28]
     a30:	e5973018 	ldr	r3, [r7, #24]
     a34:	e5d7e01f 	ldrb	lr, [r7, #31]
     a38:	e1cdc6b5 	strh	ip, [sp, #101]	; 0x65
     a3c:	e58d3061 	str	r3, [sp, #97]	; 0x61
     a40:	e5cde067 	strb	lr, [sp, #103]	; 0x67
     a44:	ebfffffe 	bl	0 <memcpy>
     a48:	e59d3038 	ldr	r3, [sp, #56]	; 0x38
     a4c:	e59d1024 	ldr	r1, [sp, #36]	; 0x24
     a50:	e59d0018 	ldr	r0, [sp, #24]
     a54:	e58d300c 	str	r3, [sp, #12]
     a58:	e59d3030 	ldr	r3, [sp, #48]	; 0x30
     a5c:	e58d3008 	str	r3, [sp, #8]
     a60:	e1cd2fd8 	ldrd	r2, [sp, #248]	; 0xf8
     a64:	e1cd20f0 	strd	r2, [sp]
     a68:	e28d2049 	add	r2, sp, #73	; 0x49
     a6c:	e59d3034 	ldr	r3, [sp, #52]	; 0x34
     a70:	e12fff33 	blx	r3
     a74:	e3a01087 	mov	r1, #135	; 0x87
     a78:	e28d0049 	add	r0, sp, #73	; 0x49
     a7c:	ebfffffe 	bl	0 <__memzero>
     a80:	e59d1020 	ldr	r1, [sp, #32]
     a84:	e28d0049 	add	r0, sp, #73	; 0x49
     a88:	ebfffffe 	bl	0 <add_device_randomness>
     a8c:	e3a00001 	mov	r0, #1
     a90:	e28dd0d4 	add	sp, sp, #212	; 0xd4
     a94:	e8bd8ff0 	pop	{r4, r5, r6, r7, r8, r9, sl, fp, pc}
     a98:	e58d3038 	str	r3, [sp, #56]	; 0x38
     a9c:	e3003000 	movw	r3, #0
     aa0:	e3002000 	movw	r2, #0
     aa4:	e3403000 	movt	r3, #0
     aa8:	e3402000 	movt	r2, #0
     aac:	e58d3034 	str	r3, [sp, #52]	; 0x34
     ab0:	e3a0b03c 	mov	fp, #60	; 0x3c
     ab4:	e3a03038 	mov	r3, #56	; 0x38
     ab8:	e58d2044 	str	r2, [sp, #68]	; 0x44
     abc:	e3a0a03f 	mov	sl, #63	; 0x3f
     ac0:	e58d3020 	str	r3, [sp, #32]
     ac4:	eaffff7a 	b	8b4 <ath_cmn_process_fft+0x160>
     ac8:	e59db01c 	ldr	fp, [sp, #28]
     acc:	e153000b 	cmp	r3, fp
     ad0:	0a00005e 	beq	c50 <ath_cmn_process_fft+0x4fc>
     ad4:	e06b5005 	rsb	r5, fp, r5
     ad8:	e2855001 	add	r5, r5, #1
     adc:	e3550003 	cmp	r5, #3
     ae0:	979ff105 	ldrls	pc, [pc, r5, lsl #2]
     ae4:	eaffffd7 	b	a48 <ath_cmn_process_fft+0x2f4>
     ae8:	00000b0c 	andeq	r0, r0, ip, lsl #22
     aec:	00000af8 	strdeq	r0, [r0], -r8
     af0:	00000b20 	andeq	r0, r0, r0, lsr #22
     af4:	000009f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     af8:	e1a0200b 	mov	r2, fp
     afc:	e1a01007 	mov	r1, r7
     b00:	e28d0049 	add	r0, sp, #73	; 0x49
     b04:	ebfffffe 	bl	0 <memcpy>
     b08:	eaffffce 	b	a48 <ath_cmn_process_fft+0x2f4>
     b0c:	e24b2001 	sub	r2, fp, #1
     b10:	e1a01007 	mov	r1, r7
     b14:	e28d004a 	add	r0, sp, #74	; 0x4a
     b18:	ebfffffe 	bl	0 <memcpy>
     b1c:	eaffffc9 	b	a48 <ath_cmn_process_fft+0x2f4>
     b20:	e597e000 	ldr	lr, [r7]
     b24:	e24b2020 	sub	r2, fp, #32
     b28:	e597c004 	ldr	ip, [r7, #4]
     b2c:	e2871021 	add	r1, r7, #33	; 0x21
     b30:	e5973008 	ldr	r3, [r7, #8]
     b34:	e28d0069 	add	r0, sp, #105	; 0x69
     b38:	e58de04a 	str	lr, [sp, #74]	; 0x4a
     b3c:	e58dc04e 	str	ip, [sp, #78]	; 0x4e
     b40:	e597e010 	ldr	lr, [r7, #16]
     b44:	e597c014 	ldr	ip, [r7, #20]
     b48:	e58d3052 	str	r3, [sp, #82]	; 0x52
     b4c:	e597300c 	ldr	r3, [r7, #12]
     b50:	e58de05a 	str	lr, [sp, #90]	; 0x5a
     b54:	e58dc05e 	str	ip, [sp, #94]	; 0x5e
     b58:	e5d7e01f 	ldrb	lr, [r7, #31]
     b5c:	e1d7c1bc 	ldrh	ip, [r7, #28]
     b60:	e58d3056 	str	r3, [sp, #86]	; 0x56
     b64:	e5973018 	ldr	r3, [r7, #24]
     b68:	e1cdc6b6 	strh	ip, [sp, #102]	; 0x66
     b6c:	e5cde068 	strb	lr, [sp, #104]	; 0x68
     b70:	e58d3062 	str	r3, [sp, #98]	; 0x62
     b74:	ebfffffe 	bl	0 <memcpy>
     b78:	eaffffb2 	b	a48 <ath_cmn_process_fft+0x2f4>
     b7c:	e58d3040 	str	r3, [sp, #64]	; 0x40
     b80:	e1a01004 	mov	r1, r4
     b84:	e59d3044 	ldr	r3, [sp, #68]	; 0x44
     b88:	e1a0000b 	mov	r0, fp
     b8c:	e58d203c 	str	r2, [sp, #60]	; 0x3c
     b90:	e12fff33 	blx	r3
     b94:	e3500000 	cmp	r0, #0
     b98:	e59d203c 	ldr	r2, [sp, #60]	; 0x3c
     b9c:	e59d3040 	ldr	r3, [sp, #64]	; 0x40
     ba0:	0a00000e 	beq	be0 <ath_cmn_process_fft+0x48c>
     ba4:	e5d7101f 	ldrb	r1, [r7, #31]
     ba8:	e5d70020 	ldrb	r0, [r7, #32]
     bac:	e59dc01c 	ldr	ip, [sp, #28]
     bb0:	e15c0005 	cmp	ip, r5
     bb4:	d1510000 	cmple	r1, r0
     bb8:	03a01001 	moveq	r1, #1
     bbc:	13a01000 	movne	r1, #0
     bc0:	e1520005 	cmp	r2, r5
     bc4:	d3a02000 	movle	r2, #0
     bc8:	c2012001 	andgt	r2, r1, #1
     bcc:	e3520000 	cmp	r2, #0
     bd0:	0a00001a 	beq	c40 <ath_cmn_process_fft+0x4ec>
     bd4:	e5db2001 	ldrb	r2, [fp, #1]
     bd8:	e3520007 	cmp	r2, #7
     bdc:	9affff6d 	bls	998 <ath_cmn_process_fft+0x244>
     be0:	e59d201c 	ldr	r2, [sp, #28]
     be4:	e1520005 	cmp	r2, r5
     be8:	1affff5e 	bne	968 <ath_cmn_process_fft+0x214>
     bec:	e58d303c 	str	r3, [sp, #60]	; 0x3c
     bf0:	e1a02007 	mov	r2, r7
     bf4:	e59d3038 	ldr	r3, [sp, #56]	; 0x38
     bf8:	e1cd8fd8 	ldrd	r8, [sp, #248]	; 0xf8
     bfc:	e59d1024 	ldr	r1, [sp, #36]	; 0x24
     c00:	e58d300c 	str	r3, [sp, #12]
     c04:	e59d3030 	ldr	r3, [sp, #48]	; 0x30
     c08:	e1cd80f0 	strd	r8, [sp]
     c0c:	e59d0018 	ldr	r0, [sp, #24]
     c10:	e58d3008 	str	r3, [sp, #8]
     c14:	e59d3034 	ldr	r3, [sp, #52]	; 0x34
     c18:	e12fff33 	blx	r3
     c1c:	e58d0028 	str	r0, [sp, #40]	; 0x28
     c20:	e1a00007 	mov	r0, r7
     c24:	e59d1020 	ldr	r1, [sp, #32]
     c28:	ebfffffe 	bl	0 <add_device_randomness>
     c2c:	e59d3010 	ldr	r3, [sp, #16]
     c30:	e153000a 	cmp	r3, sl
     c34:	e59d303c 	ldr	r3, [sp, #60]	; 0x3c
     c38:	caffff4d 	bgt	974 <ath_cmn_process_fft+0x220>
     c3c:	eaffff92 	b	a8c <ath_cmn_process_fft+0x338>
     c40:	e59d202c 	ldr	r2, [sp, #44]	; 0x2c
     c44:	e1520005 	cmp	r2, r5
     c48:	1affffe4 	bne	be0 <ath_cmn_process_fft+0x48c>
     c4c:	eaffffe0 	b	bd4 <ath_cmn_process_fft+0x480>
     c50:	e59d3038 	ldr	r3, [sp, #56]	; 0x38
     c54:	e59d1024 	ldr	r1, [sp, #36]	; 0x24
     c58:	e59d0018 	ldr	r0, [sp, #24]
     c5c:	e58d300c 	str	r3, [sp, #12]
     c60:	e59d3030 	ldr	r3, [sp, #48]	; 0x30
     c64:	e58d3008 	str	r3, [sp, #8]
     c68:	e1cd2fd8 	ldrd	r2, [sp, #248]	; 0xf8
     c6c:	e1cd20f0 	strd	r2, [sp]
     c70:	e1a02007 	mov	r2, r7
     c74:	e59d3034 	ldr	r3, [sp, #52]	; 0x34
     c78:	e12fff33 	blx	r3
     c7c:	e1a00007 	mov	r0, r7
     c80:	e59d1020 	ldr	r1, [sp, #32]
     c84:	ebfffffe 	bl	0 <add_device_randomness>
     c88:	e3a00001 	mov	r0, #1
     c8c:	eaffff7f 	b	a90 <ath_cmn_process_fft+0x33c>
     c90:	e59d201c 	ldr	r2, [sp, #28]
     c94:	e1530002 	cmp	r3, r2
     c98:	0affffd3 	beq	bec <ath_cmn_process_fft+0x498>
     c9c:	e59db01c 	ldr	fp, [sp, #28]
     ca0:	eaffff8b 	b	ad4 <ath_cmn_process_fft+0x380>
     ca4:	e3000000 	movw	r0, #0
     ca8:	e300119a 	movw	r1, #410	; 0x19a
     cac:	e3400000 	movt	r0, #0
     cb0:	e3a03000 	mov	r3, #0
     cb4:	e58d3038 	str	r3, [sp, #56]	; 0x38
     cb8:	ebfffffe 	bl	0 <warn_slowpath_null>
     cbc:	eaffff76 	b	a9c <ath_cmn_process_fft+0x348>
     cc0:	e3a03000 	mov	r3, #0
     cc4:	e58d3038 	str	r3, [sp, #56]	; 0x38
     cc8:	eaffff73 	b	a9c <ath_cmn_process_fft+0x348>
