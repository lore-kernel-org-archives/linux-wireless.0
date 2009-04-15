Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.185]:2805 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbZDOPNo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 11:13:44 -0400
Received: by mu-out-0910.google.com with SMTP id g7so1236492muf.1
        for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2009 08:13:40 -0700 (PDT)
Message-ID: <49E5F99E.1090809@tuffmail.co.uk> (sfid-20090415_171354_580953_E3DDB5B8)
Date: Wed, 15 Apr 2009 16:13:34 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Bob Copeland <bcopeland@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath5k-devel] BUG in freq_reg_info_regd
References: <9b2b86520904150345r31851012jb6a231e02583038a@mail.gmail.com>	 <9b2b86520904150358u81dd977g3378ef81d7748355@mail.gmail.com>	 <20090415130232.GA21411@tuxdriver.com> <49E5EC66.80408@tuffmail.co.uk> <b6c5339f0904150809p308d8eedt83198f12a7887f7e@mail.gmail.com>
In-Reply-To: <b6c5339f0904150809p308d8eedt83198f12a7887f7e@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050805070301050509070409"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050805070301050509070409
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Bob Copeland wrote:
> On Wed, Apr 15, 2009 at 10:17 AM, Alan Jenkins
> <alan-jenkins@tuffmail.co.uk> wrote:
>   
>>>> Um, also the new "ath" module taints the kernel
>>>>         
>
> Christian Lamparter posted a patch for that yesterday.
>
>   
>> [    4.176459] ath: Country alpha2 being used: 00
>> [    4.176556] ath: Regpair detected: 0x60
>> [    4.176679] BUG: unable to handle kernel NULL pointer dereference at
>> 00000004
>> [    4.176874] IP: [<dffede2e>] freq_reg_info_regd+0x2a/0xf2 [cfg80211]
>> [    4.177053] *pdpt = 0000000017451001 *pde = 0000000000000000
>> [    4.177245] Oops: 0000 [#2]
>> [    4.177376] last sysfs file: /sys/class/input/input5/modalias
>> [    4.177477] Modules linked in: ath5k(+) snd_hwdep snd_pcm_oss
>> snd_mixer_oss uhci_hcd ehci_hcd mac80211 i2c_i801 led_class ath(P)
>> psmouse serio_raw snd_pcm i2c_core pcspkr cfg80211 atl2 intel_agp
>> snd_timer snd_page_alloc usbcore agpgart eeepc_laptop video backlight
>> output battery rfkill ac processor button evdev thermal fan ata_generic
>> [    4.179388]
>> [    4.179475] Pid: 1641, comm: modprobe Tainted: P      D
>> (2.6.30-rc1-wleeepc #11) 701
>> [    4.179615] EIP: 0060:[<dffede2e>] EFLAGS: 00010286 CPU: 0
>> [    4.179732] EIP is at freq_reg_info_regd+0x2a/0xf2 [cfg80211]
>> [    4.179834] EAX: 00000000 EBX: df200060 ECX: 00004e20 EDX: e0099524
>> [    4.179938] ESI: 00000060 EDI: 0024cde0 EBP: de551d70 ESP: de551d50
>> [    4.180003]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
>> [    4.180003] Process modprobe (pid: 1641, ti=de550000 task=de833000
>> task.ti=de550000)
>>     
>
> Hmm, null pointer is probably custom_regd since reg_rule comes from
> the stack and wiphy should've been validated a lot earlier.
>
> Mind posting the objdump -S net/wireless/reg.o ?
>   

Sure.  It's 120k so I trimmed the CC list.

--------------050805070301050509070409
Content-Type: text/plain;
 name="reg.S"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="reg.S"


net/wireless/reg.o:     file format elf32-i386


Disassembly of section .text:

00000000 <is_old_static_regdom>:
       0:	55                   	push   %ebp
       1:	3d 0c 00 00 00       	cmp    $0xc,%eax
       6:	89 e5                	mov    %esp,%ebp
       8:	74 14                	je     1e <is_old_static_regdom+0x1e>
       a:	3d a4 00 00 00       	cmp    $0xa4,%eax
       f:	74 0d                	je     1e <is_old_static_regdom+0x1e>
      11:	3d f4 00 00 00       	cmp    $0xf4,%eax
      16:	0f 94 c0             	sete   %al
      19:	0f b6 c0             	movzbl %al,%eax
      1c:	eb 05                	jmp    23 <is_old_static_regdom+0x23>
      1e:	b8 01 00 00 00       	mov    $0x1,%eax
      23:	5d                   	pop    %ebp
      24:	c3                   	ret    

00000025 <is_world_regdom>:
      25:	55                   	push   %ebp
      26:	85 c0                	test   %eax,%eax
      28:	89 e5                	mov    %esp,%ebp
      2a:	74 11                	je     3d <is_world_regdom+0x18>
      2c:	80 38 30             	cmpb   $0x30,(%eax)
      2f:	75 0c                	jne    3d <is_world_regdom+0x18>
      31:	80 78 01 30          	cmpb   $0x30,0x1(%eax)
      35:	0f 94 c0             	sete   %al
      38:	0f b6 c0             	movzbl %al,%eax
      3b:	eb 02                	jmp    3f <is_world_regdom+0x1a>
      3d:	31 c0                	xor    %eax,%eax
      3f:	5d                   	pop    %ebp
      40:	c3                   	ret    

00000041 <is_unknown_alpha2>:
      41:	55                   	push   %ebp
      42:	85 c0                	test   %eax,%eax
      44:	89 e5                	mov    %esp,%ebp
      46:	74 11                	je     59 <is_unknown_alpha2+0x18>
      48:	80 38 39             	cmpb   $0x39,(%eax)
      4b:	75 0c                	jne    59 <is_unknown_alpha2+0x18>
      4d:	80 78 01 39          	cmpb   $0x39,0x1(%eax)
      51:	0f 94 c0             	sete   %al
      54:	0f b6 c0             	movzbl %al,%eax
      57:	eb 02                	jmp    5b <is_unknown_alpha2+0x1a>
      59:	31 c0                	xor    %eax,%eax
      5b:	5d                   	pop    %ebp
      5c:	c3                   	ret    

0000005d <is_an_alpha2>:
      5d:	55                   	push   %ebp
      5e:	85 c0                	test   %eax,%eax
      60:	89 e5                	mov    %esp,%ebp
      62:	89 c2                	mov    %eax,%edx
      64:	74 17                	je     7d <is_an_alpha2+0x20>
      66:	8a 00                	mov    (%eax),%al
      68:	2c 41                	sub    $0x41,%al
      6a:	3c 19                	cmp    $0x19,%al
      6c:	77 0f                	ja     7d <is_an_alpha2+0x20>
      6e:	8a 42 01             	mov    0x1(%edx),%al
      71:	2c 41                	sub    $0x41,%al
      73:	3c 19                	cmp    $0x19,%al
      75:	0f 96 c0             	setbe  %al
      78:	0f b6 c0             	movzbl %al,%eax
      7b:	eb 02                	jmp    7f <is_an_alpha2+0x22>
      7d:	31 c0                	xor    %eax,%eax
      7f:	5d                   	pop    %ebp
      80:	c3                   	ret    

00000081 <alpha2_equal>:
      81:	55                   	push   %ebp
      82:	85 c0                	test   %eax,%eax
      84:	89 e5                	mov    %esp,%ebp
      86:	89 c1                	mov    %eax,%ecx
      88:	74 18                	je     a2 <alpha2_equal+0x21>
      8a:	85 d2                	test   %edx,%edx
      8c:	74 14                	je     a2 <alpha2_equal+0x21>
      8e:	8a 00                	mov    (%eax),%al
      90:	3a 02                	cmp    (%edx),%al
      92:	75 0e                	jne    a2 <alpha2_equal+0x21>
      94:	8a 41 01             	mov    0x1(%ecx),%al
      97:	3a 42 01             	cmp    0x1(%edx),%al
      9a:	0f 94 c0             	sete   %al
      9d:	0f b6 c0             	movzbl %al,%eax
      a0:	eb 02                	jmp    a4 <alpha2_equal+0x23>
      a2:	31 c0                	xor    %eax,%eax
      a4:	5d                   	pop    %ebp
      a5:	c3                   	ret    

000000a6 <reg_is_valid_request>:
      a6:	89 c2                	mov    %eax,%edx
      a8:	a1 04 00 00 00       	mov    0x4,%eax
      ad:	31 c9                	xor    %ecx,%ecx
      af:	55                   	push   %ebp
      b0:	89 e5                	mov    %esp,%ebp
      b2:	85 c0                	test   %eax,%eax
      b4:	74 0b                	je     c1 <reg_is_valid_request+0x1b>
      b6:	83 c0 08             	add    $0x8,%eax
      b9:	e8 c3 ff ff ff       	call   81 <alpha2_equal>
      be:	0f b6 c8             	movzbl %al,%ecx
      c1:	5d                   	pop    %ebp
      c2:	89 c8                	mov    %ecx,%eax
      c4:	c3                   	ret    

000000c5 <is_valid_reg_rule>:
      c5:	55                   	push   %ebp
      c6:	8b 08                	mov    (%eax),%ecx
      c8:	89 e5                	mov    %esp,%ebp
      ca:	85 c9                	test   %ecx,%ecx
      cc:	74 1c                	je     ea <is_valid_reg_rule+0x25>
      ce:	8b 50 04             	mov    0x4(%eax),%edx
      d1:	85 d2                	test   %edx,%edx
      d3:	74 15                	je     ea <is_valid_reg_rule+0x25>
      d5:	39 d1                	cmp    %edx,%ecx
      d7:	77 11                	ja     ea <is_valid_reg_rule+0x25>
      d9:	39 ca                	cmp    %ecx,%edx
      db:	76 0d                	jbe    ea <is_valid_reg_rule+0x25>
      dd:	29 ca                	sub    %ecx,%edx
      df:	39 50 08             	cmp    %edx,0x8(%eax)
      e2:	0f 96 c0             	setbe  %al
      e5:	0f b6 c0             	movzbl %al,%eax
      e8:	eb 02                	jmp    ec <is_valid_reg_rule+0x27>
      ea:	31 c0                	xor    %eax,%eax
      ec:	5d                   	pop    %ebp
      ed:	c3                   	ret    

000000ee <reg_rules_intersect>:
      ee:	55                   	push   %ebp
      ef:	89 e5                	mov    %esp,%ebp
      f1:	57                   	push   %edi
      f2:	89 c7                	mov    %eax,%edi
      f4:	56                   	push   %esi
      f5:	89 ce                	mov    %ecx,%esi
      f7:	53                   	push   %ebx
      f8:	89 d3                	mov    %edx,%ebx
      fa:	8b 08                	mov    (%eax),%ecx
      fc:	39 0a                	cmp    %ecx,(%edx)
      fe:	0f 43 0a             	cmovae (%edx),%ecx
     101:	8b 50 04             	mov    0x4(%eax),%edx
     104:	39 53 04             	cmp    %edx,0x4(%ebx)
     107:	8b 40 08             	mov    0x8(%eax),%eax
     10a:	0f 46 53 04          	cmovbe 0x4(%ebx),%edx
     10e:	39 43 08             	cmp    %eax,0x8(%ebx)
     111:	89 0e                	mov    %ecx,(%esi)
     113:	0f 46 43 08          	cmovbe 0x8(%ebx),%eax
     117:	89 56 04             	mov    %edx,0x4(%esi)
     11a:	29 ca                	sub    %ecx,%edx
     11c:	39 d0                	cmp    %edx,%eax
     11e:	89 46 08             	mov    %eax,0x8(%esi)
     121:	76 03                	jbe    126 <reg_rules_intersect+0x38>
     123:	89 56 08             	mov    %edx,0x8(%esi)
     126:	8b 47 10             	mov    0x10(%edi),%eax
     129:	39 43 10             	cmp    %eax,0x10(%ebx)
     12c:	0f 46 43 10          	cmovbe 0x10(%ebx),%eax
     130:	89 46 10             	mov    %eax,0x10(%esi)
     133:	8b 47 0c             	mov    0xc(%edi),%eax
     136:	39 43 0c             	cmp    %eax,0xc(%ebx)
     139:	0f 46 43 0c          	cmovbe 0xc(%ebx),%eax
     13d:	89 46 0c             	mov    %eax,0xc(%esi)
     140:	8b 47 14             	mov    0x14(%edi),%eax
     143:	0b 43 14             	or     0x14(%ebx),%eax
     146:	89 46 14             	mov    %eax,0x14(%esi)
     149:	89 f0                	mov    %esi,%eax
     14b:	e8 75 ff ff ff       	call   c5 <is_valid_reg_rule>
     150:	5b                   	pop    %ebx
     151:	3c 01                	cmp    $0x1,%al
     153:	5e                   	pop    %esi
     154:	19 c0                	sbb    %eax,%eax
     156:	83 e0 ea             	and    $0xffffffea,%eax
     159:	5f                   	pop    %edi
     15a:	5d                   	pop    %ebp
     15b:	c3                   	ret    

0000015c <map_regdom_flags>:
     15c:	89 c1                	mov    %eax,%ecx
     15e:	24 80                	and    $0x80,%al
     160:	3c 01                	cmp    $0x1,%al
     162:	19 c0                	sbb    %eax,%eax
     164:	f7 d0                	not    %eax
     166:	83 e0 02             	and    $0x2,%eax
     169:	89 c2                	mov    %eax,%edx
     16b:	83 ca 04             	or     $0x4,%edx
     16e:	f6 c5 01             	test   $0x1,%ch
     171:	0f 45 c2             	cmovne %edx,%eax
     174:	55                   	push   %ebp
     175:	89 c2                	mov    %eax,%edx
     177:	89 e5                	mov    %esp,%ebp
     179:	83 ca 08             	or     $0x8,%edx
     17c:	5d                   	pop    %ebp
     17d:	f6 c1 10             	test   $0x10,%cl
     180:	0f 45 c2             	cmovne %edx,%eax
     183:	c3                   	ret    

00000184 <freq_reg_info_regd>:
     184:	55                   	push   %ebp
     185:	89 e5                	mov    %esp,%ebp
     187:	57                   	push   %edi
     188:	89 d7                	mov    %edx,%edi
     18a:	56                   	push   %esi
     18b:	ba 20 4e 00 00       	mov    $0x4e20,%edx
     190:	53                   	push   %ebx
     191:	89 c3                	mov    %eax,%ebx
     193:	83 ec 14             	sub    $0x14,%esp
     196:	85 c9                	test   %ecx,%ecx
     198:	8b 45 0c             	mov    0xc(%ebp),%eax
     19b:	0f 44 ca             	cmove  %edx,%ecx
     19e:	8b 15 00 00 00 00    	mov    0x0,%edx
     1a4:	85 c0                	test   %eax,%eax
     1a6:	0f 45 d0             	cmovne %eax,%edx
     1a9:	a1 04 00 00 00       	mov    0x4,%eax
     1ae:	8b 40 04             	mov    0x4(%eax),%eax
     1b1:	83 f8 03             	cmp    $0x3,%eax
     1b4:	74 26                	je     1dc <freq_reg_info_regd+0x58>
     1b6:	48                   	dec    %eax
     1b7:	74 23                	je     1dc <freq_reg_info_regd+0x58>
     1b9:	8b 73 30             	mov    0x30(%ebx),%esi
     1bc:	85 f6                	test   %esi,%esi
     1be:	74 1c                	je     1dc <freq_reg_info_regd+0x58>
     1c0:	8b 06                	mov    (%esi),%eax
     1c2:	d1 e9                	shr    %ecx
     1c4:	31 d2                	xor    %edx,%edx
     1c6:	8d 5e 08             	lea    0x8(%esi),%ebx
     1c9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     1d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
     1d3:	89 f8                	mov    %edi,%eax
     1d5:	29 c8                	sub    %ecx,%eax
     1d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     1da:	eb 7c                	jmp    258 <freq_reg_info_regd+0xd4>
     1dc:	85 d2                	test   %edx,%edx
     1de:	89 d6                	mov    %edx,%esi
     1e0:	75 de                	jne    1c0 <freq_reg_info_regd+0x3c>
     1e2:	e9 82 00 00 00       	jmp    269 <freq_reg_info_regd+0xe5>
     1e7:	6b 45 ec 18          	imul   $0x18,-0x14(%ebp),%eax
     1eb:	84 d2                	test   %dl,%dl
     1ed:	8d 44 06 08          	lea    0x8(%esi,%eax,1),%eax
     1f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
     1f4:	75 29                	jne    21f <freq_reg_info_regd+0x9b>
     1f6:	89 f8                	mov    %edi,%eax
     1f8:	2b 03                	sub    (%ebx),%eax
     1fa:	99                   	cltd   
     1fb:	31 d0                	xor    %edx,%eax
     1fd:	29 d0                	sub    %edx,%eax
     1ff:	ba 01 00 00 00       	mov    $0x1,%edx
     204:	3d 80 84 1e 00       	cmp    $0x1e8480,%eax
     209:	7e 14                	jle    21f <freq_reg_info_regd+0x9b>
     20b:	89 f8                	mov    %edi,%eax
     20d:	2b 43 04             	sub    0x4(%ebx),%eax
     210:	99                   	cltd   
     211:	31 d0                	xor    %edx,%eax
     213:	29 d0                	sub    %edx,%eax
     215:	31 d2                	xor    %edx,%edx
     217:	3d 80 84 1e 00       	cmp    $0x1e8480,%eax
     21c:	0f 9e c2             	setle  %dl
     21f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
     226:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     229:	3b 03                	cmp    (%ebx),%eax
     22b:	72 0f                	jb     23c <freq_reg_info_regd+0xb8>
     22d:	8d 04 39             	lea    (%ecx,%edi,1),%eax
     230:	3b 43 04             	cmp    0x4(%ebx),%eax
     233:	0f 96 c0             	setbe  %al
     236:	0f b6 c0             	movzbl %al,%eax
     239:	89 45 e0             	mov    %eax,-0x20(%ebp)
     23c:	84 d2                	test   %dl,%dl
     23e:	74 12                	je     252 <freq_reg_info_regd+0xce>
     240:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     244:	74 0c                	je     252 <freq_reg_info_regd+0xce>
     246:	8b 45 08             	mov    0x8(%ebp),%eax
     249:	8b 55 f0             	mov    -0x10(%ebp),%edx
     24c:	89 10                	mov    %edx,(%eax)
     24e:	31 c0                	xor    %eax,%eax
     250:	eb 1c                	jmp    26e <freq_reg_info_regd+0xea>
     252:	ff 45 ec             	incl   -0x14(%ebp)
     255:	83 c3 18             	add    $0x18,%ebx
     258:	8b 45 e8             	mov    -0x18(%ebp),%eax
     25b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
     25e:	75 87                	jne    1e7 <freq_reg_info_regd+0x63>
     260:	84 d2                	test   %dl,%dl
     262:	b8 de ff ff ff       	mov    $0xffffffde,%eax
     267:	74 05                	je     26e <freq_reg_info_regd+0xea>
     269:	b8 ea ff ff ff       	mov    $0xffffffea,%eax
     26e:	83 c4 14             	add    $0x14,%esp
     271:	5b                   	pop    %ebx
     272:	5e                   	pop    %esi
     273:	5f                   	pop    %edi
     274:	5d                   	pop    %ebp
     275:	c3                   	ret    

00000276 <freq_reg_info>:
     276:	55                   	push   %ebp
     277:	89 e5                	mov    %esp,%ebp
     279:	6a 00                	push   $0x0
     27b:	ff 75 08             	pushl  0x8(%ebp)
     27e:	e8 01 ff ff ff       	call   184 <freq_reg_info_regd>
     283:	c9                   	leave  
     284:	c3                   	ret    

00000285 <is_ht40_not_allowed>:
     285:	55                   	push   %ebp
     286:	85 c0                	test   %eax,%eax
     288:	89 e5                	mov    %esp,%ebp
     28a:	74 15                	je     2a1 <is_ht40_not_allowed+0x1c>
     28c:	8b 40 0c             	mov    0xc(%eax),%eax
     28f:	a8 01                	test   $0x1,%al
     291:	75 0e                	jne    2a1 <is_ht40_not_allowed+0x1c>
     293:	83 e0 30             	and    $0x30,%eax
     296:	83 f8 30             	cmp    $0x30,%eax
     299:	0f 94 c0             	sete   %al
     29c:	0f b6 c0             	movzbl %al,%eax
     29f:	eb 05                	jmp    2a6 <is_ht40_not_allowed+0x21>
     2a1:	b8 01 00 00 00       	mov    $0x1,%eax
     2a6:	5d                   	pop    %ebp
     2a7:	c3                   	ret    

000002a8 <reset_regdomains>:
     2a8:	a1 2c 00 00 00       	mov    0x2c,%eax
     2ad:	39 05 00 00 00 00    	cmp    %eax,0x0
     2b3:	55                   	push   %ebp
     2b4:	89 e5                	mov    %esp,%ebp
     2b6:	75 0a                	jne    2c2 <reset_regdomains+0x1a>
     2b8:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
     2bf:	00 00 00 
     2c2:	3d 8c 01 00 00       	cmp    $0x18c,%eax
     2c7:	75 0a                	jne    2d3 <reset_regdomains+0x2b>
     2c9:	c7 05 2c 00 00 00 00 	movl   $0x0,0x2c
     2d0:	00 00 00 
     2d3:	81 3d 00 00 00 00 8c 	cmpl   $0x18c,0x0
     2da:	01 00 00 
     2dd:	75 0a                	jne    2e9 <reset_regdomains+0x41>
     2df:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
     2e6:	00 00 00 
     2e9:	a1 00 00 00 00       	mov    0x0,%eax
     2ee:	e8 0d fd ff ff       	call   0 <is_old_static_regdom>
     2f3:	84 c0                	test   %al,%al
     2f5:	74 0a                	je     301 <reset_regdomains+0x59>
     2f7:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
     2fe:	00 00 00 
     301:	a1 00 00 00 00       	mov    0x0,%eax
     306:	e8 fc ff ff ff       	call   307 <reset_regdomains+0x5f>
     30b:	a1 2c 00 00 00       	mov    0x2c,%eax
     310:	e8 fc ff ff ff       	call   311 <reset_regdomains+0x69>
     315:	c7 05 2c 00 00 00 8c 	movl   $0x18c,0x2c
     31c:	01 00 00 
     31f:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
     326:	00 00 00 
     329:	5d                   	pop    %ebp
     32a:	c3                   	ret    

0000032b <wiphy_apply_custom_regulatory>:
     32b:	55                   	push   %ebp
     32c:	89 e5                	mov    %esp,%ebp
     32e:	57                   	push   %edi
     32f:	56                   	push   %esi
     330:	53                   	push   %ebx
     331:	83 ec 20             	sub    $0x20,%esp
     334:	89 45 dc             	mov    %eax,-0x24(%ebp)
     337:	89 55 d8             	mov    %edx,-0x28(%ebp)
     33a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
     341:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     348:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     34b:	8b 55 dc             	mov    -0x24(%ebp),%edx
     34e:	8b 44 82 24          	mov    0x24(%edx,%eax,4),%eax
     352:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
     359:	85 c0                	test   %eax,%eax
     35b:	89 45 e0             	mov    %eax,-0x20(%ebp)
     35e:	0f 85 94 00 00 00    	jne    3f8 <wiphy_apply_custom_regulatory+0xcd>
     364:	e9 9e 00 00 00       	jmp    407 <wiphy_apply_custom_regulatory+0xdc>
     369:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     36c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
     36f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     376:	8b 44 91 24          	mov    0x24(%ecx,%edx,4),%eax
     37a:	8b 55 e8             	mov    -0x18(%ebp),%edx
     37d:	3b 50 0c             	cmp    0xc(%eax),%edx
     380:	72 04                	jb     386 <wiphy_apply_custom_regulatory+0x5b>
     382:	0f 0b                	ud2a   
     384:	eb fe                	jmp    384 <wiphy_apply_custom_regulatory+0x59>
     386:	6b 7d e8 28          	imul   $0x28,-0x18(%ebp),%edi
     38a:	8d 4d f0             	lea    -0x10(%ebp),%ecx
     38d:	03 38                	add    (%eax),%edi
     38f:	8b 45 dc             	mov    -0x24(%ebp),%eax
     392:	0f b7 57 04          	movzwl 0x4(%edi),%edx
     396:	ff 75 d8             	pushl  -0x28(%ebp)
     399:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
     39f:	51                   	push   %ecx
     3a0:	b9 20 4e 00 00       	mov    $0x4e20,%ecx
     3a5:	e8 da fd ff ff       	call   184 <freq_reg_info_regd>
     3aa:	5a                   	pop    %edx
     3ab:	85 c0                	test   %eax,%eax
     3ad:	59                   	pop    %ecx
     3ae:	74 09                	je     3b9 <wiphy_apply_custom_regulatory+0x8e>
     3b0:	c7 47 0c 01 00 00 00 	movl   $0x1,0xc(%edi)
     3b7:	eb 3c                	jmp    3f5 <wiphy_apply_custom_regulatory+0xca>
     3b9:	8b 75 f0             	mov    -0x10(%ebp),%esi
     3bc:	8b 46 14             	mov    0x14(%esi),%eax
     3bf:	81 7e 08 40 9c 00 00 	cmpl   $0x9c40,0x8(%esi)
     3c6:	19 db                	sbb    %ebx,%ebx
     3c8:	e8 8f fd ff ff       	call   15c <map_regdom_flags>
     3cd:	83 e3 30             	and    $0x30,%ebx
     3d0:	31 d2                	xor    %edx,%edx
     3d2:	0b 47 0c             	or     0xc(%edi),%eax
     3d5:	09 c3                	or     %eax,%ebx
     3d7:	89 5f 0c             	mov    %ebx,0xc(%edi)
     3da:	bb 64 00 00 00       	mov    $0x64,%ebx
     3df:	8b 46 0c             	mov    0xc(%esi),%eax
     3e2:	c6 47 06 14          	movb   $0x14,0x6(%edi)
     3e6:	f7 f3                	div    %ebx
     3e8:	31 d2                	xor    %edx,%edx
     3ea:	89 47 10             	mov    %eax,0x10(%edi)
     3ed:	8b 46 10             	mov    0x10(%esi),%eax
     3f0:	f7 f3                	div    %ebx
     3f2:	89 47 14             	mov    %eax,0x14(%edi)
     3f5:	ff 45 e8             	incl   -0x18(%ebp)
     3f8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
     3fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
     3fe:	3b 41 0c             	cmp    0xc(%ecx),%eax
     401:	0f 82 62 ff ff ff    	jb     369 <wiphy_apply_custom_regulatory+0x3e>
     407:	ff 45 ec             	incl   -0x14(%ebp)
     40a:	ff 45 e4             	incl   -0x1c(%ebp)
     40d:	83 7d ec 02          	cmpl   $0x2,-0x14(%ebp)
     411:	0f 85 31 ff ff ff    	jne    348 <wiphy_apply_custom_regulatory+0x1d>
     417:	8d 65 f4             	lea    -0xc(%ebp),%esp
     41a:	5b                   	pop    %ebx
     41b:	5e                   	pop    %esi
     41c:	5f                   	pop    %edi
     41d:	5d                   	pop    %ebp
     41e:	c3                   	ret    

0000041f <country_ie_integrity_changes>:
     41f:	89 c1                	mov    %eax,%ecx
     421:	a1 04 00 00 00       	mov    0x4,%eax
     426:	55                   	push   %ebp
     427:	89 e5                	mov    %esp,%ebp
     429:	8b 50 0c             	mov    0xc(%eax),%edx
     42c:	31 c0                	xor    %eax,%eax
     42e:	85 d2                	test   %edx,%edx
     430:	74 07                	je     439 <country_ie_integrity_changes+0x1a>
     432:	31 c0                	xor    %eax,%eax
     434:	39 ca                	cmp    %ecx,%edx
     436:	0f 95 c0             	setne  %al
     439:	5d                   	pop    %ebp
     43a:	c3                   	ret    

0000043b <regdom_changes>:
     43b:	55                   	push   %ebp
     43c:	89 e5                	mov    %esp,%ebp
     43e:	53                   	push   %ebx
     43f:	89 c3                	mov    %eax,%ebx
     441:	a1 00 00 00 00       	mov    0x0,%eax
     446:	48                   	dec    %eax
     447:	75 11                	jne    45a <regdom_changes+0x1f>
     449:	6a 00                	push   $0x0
     44b:	6a 4e                	push   $0x4e
     44d:	68 13 00 00 00       	push   $0x13
     452:	e8 fc ff ff ff       	call   453 <regdom_changes+0x18>
     457:	83 c4 0c             	add    $0xc,%esp
     45a:	a1 00 00 00 00       	mov    0x0,%eax
     45f:	ba 01 00 00 00       	mov    $0x1,%edx
     464:	85 c0                	test   %eax,%eax
     466:	74 0f                	je     477 <regdom_changes+0x3c>
     468:	89 da                	mov    %ebx,%edx
     46a:	83 c0 04             	add    $0x4,%eax
     46d:	e8 0f fc ff ff       	call   81 <alpha2_equal>
     472:	34 01                	xor    $0x1,%al
     474:	0f b6 d0             	movzbl %al,%edx
     477:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     47a:	89 d0                	mov    %edx,%eax
     47c:	c9                   	leave  
     47d:	c3                   	ret    

0000047e <reg_device_remove>:
     47e:	55                   	push   %ebp
     47f:	89 e5                	mov    %esp,%ebp
     481:	56                   	push   %esi
     482:	89 c6                	mov    %eax,%esi
     484:	a1 00 00 00 00       	mov    0x0,%eax
     489:	53                   	push   %ebx
     48a:	48                   	dec    %eax
     48b:	75 11                	jne    49e <reg_device_remove+0x20>
     48d:	6a 00                	push   $0x0
     48f:	6a 4e                	push   $0x4e
     491:	68 13 00 00 00       	push   $0x13
     496:	e8 fc ff ff ff       	call   497 <reg_device_remove+0x19>
     49b:	83 c4 0c             	add    $0xc,%esp
     49e:	a1 04 00 00 00       	mov    0x4,%eax
     4a3:	31 db                	xor    %ebx,%ebx
     4a5:	85 c0                	test   %eax,%eax
     4a7:	74 09                	je     4b2 <reg_device_remove+0x34>
     4a9:	8b 00                	mov    (%eax),%eax
     4ab:	e8 fc ff ff ff       	call   4ac <reg_device_remove+0x2e>
     4b0:	89 c3                	mov    %eax,%ebx
     4b2:	8b 46 30             	mov    0x30(%esi),%eax
     4b5:	e8 fc ff ff ff       	call   4b6 <reg_device_remove+0x38>
     4ba:	a1 04 00 00 00       	mov    0x4,%eax
     4bf:	85 c0                	test   %eax,%eax
     4c1:	74 15                	je     4d8 <reg_device_remove+0x5a>
     4c3:	85 db                	test   %ebx,%ebx
     4c5:	74 11                	je     4d8 <reg_device_remove+0x5a>
     4c7:	39 f3                	cmp    %esi,%ebx
     4c9:	75 0d                	jne    4d8 <reg_device_remove+0x5a>
     4cb:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
     4d1:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
     4d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
     4db:	5b                   	pop    %ebx
     4dc:	5e                   	pop    %esi
     4dd:	5d                   	pop    %ebp
     4de:	c3                   	ret    

000004df <reg_copy_regd>:
     4df:	55                   	push   %ebp
     4e0:	89 e5                	mov    %esp,%ebp
     4e2:	57                   	push   %edi
     4e3:	56                   	push   %esi
     4e4:	53                   	push   %ebx
     4e5:	89 d3                	mov    %edx,%ebx
     4e7:	83 ec 08             	sub    $0x8,%esp
     4ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
     4ed:	8b 02                	mov    (%edx),%eax
     4ef:	ba d0 80 00 00       	mov    $0x80d0,%edx
     4f4:	40                   	inc    %eax
     4f5:	6b c0 18             	imul   $0x18,%eax,%eax
     4f8:	83 c0 08             	add    $0x8,%eax
     4fb:	e8 fc ff ff ff       	call   4fc <reg_copy_regd+0x1d>
     500:	89 c2                	mov    %eax,%edx
     502:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
     507:	85 d2                	test   %edx,%edx
     509:	74 37                	je     542 <reg_copy_regd+0x63>
     50b:	8b 03                	mov    (%ebx),%eax
     50d:	89 02                	mov    %eax,(%edx)
     50f:	8b 43 04             	mov    0x4(%ebx),%eax
     512:	89 42 04             	mov    %eax,0x4(%edx)
     515:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     51c:	eb 16                	jmp    534 <reg_copy_regd+0x55>
     51e:	6b 45 f0 18          	imul   $0x18,-0x10(%ebp),%eax
     522:	b9 06 00 00 00       	mov    $0x6,%ecx
     527:	8d 7c 02 08          	lea    0x8(%edx,%eax,1),%edi
     52b:	8d 74 03 08          	lea    0x8(%ebx,%eax,1),%esi
     52f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
     531:	ff 45 f0             	incl   -0x10(%ebp)
     534:	8b 45 f0             	mov    -0x10(%ebp),%eax
     537:	3b 03                	cmp    (%ebx),%eax
     539:	72 e3                	jb     51e <reg_copy_regd+0x3f>
     53b:	8b 45 ec             	mov    -0x14(%ebp),%eax
     53e:	89 10                	mov    %edx,(%eax)
     540:	31 c0                	xor    %eax,%eax
     542:	5b                   	pop    %ebx
     543:	5e                   	pop    %esi
     544:	5b                   	pop    %ebx
     545:	5e                   	pop    %esi
     546:	5f                   	pop    %edi
     547:	5d                   	pop    %ebp
     548:	c3                   	ret    

00000549 <regdom_intersect>:
     549:	55                   	push   %ebp
     54a:	b9 06 00 00 00       	mov    $0x6,%ecx
     54f:	89 e5                	mov    %esp,%ebp
     551:	57                   	push   %edi
     552:	56                   	push   %esi
     553:	53                   	push   %ebx
     554:	8d 5d dc             	lea    -0x24(%ebp),%ebx
     557:	83 ec 34             	sub    $0x34,%esp
     55a:	89 df                	mov    %ebx,%edi
     55c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
     55f:	31 c0                	xor    %eax,%eax
     561:	89 55 c0             	mov    %edx,-0x40(%ebp)
     564:	f3 ab                	rep stos %eax,%es:(%edi)
     566:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
     56a:	0f 84 f5 00 00 00    	je     665 <regdom_intersect+0x11c>
     570:	85 d2                	test   %edx,%edx
     572:	0f 84 ed 00 00 00    	je     665 <regdom_intersect+0x11c>
     578:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
     57f:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
     586:	eb 44                	jmp    5cc <regdom_intersect+0x83>
     588:	6b 45 c8 18          	imul   $0x18,-0x38(%ebp),%eax
     58c:	31 f6                	xor    %esi,%esi
     58e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
     591:	8d 44 02 08          	lea    0x8(%edx,%eax,1),%eax
     595:	89 45 d0             	mov    %eax,-0x30(%ebp)
     598:	eb 28                	jmp    5c2 <regdom_intersect+0x79>
     59a:	6b c6 18             	imul   $0x18,%esi,%eax
     59d:	8b 4d c0             	mov    -0x40(%ebp),%ecx
     5a0:	89 df                	mov    %ebx,%edi
     5a2:	8d 54 01 08          	lea    0x8(%ecx,%eax,1),%edx
     5a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
     5a9:	8d 4d dc             	lea    -0x24(%ebp),%ecx
     5ac:	e8 3d fb ff ff       	call   ee <reg_rules_intersect>
     5b1:	b9 06 00 00 00       	mov    $0x6,%ecx
     5b6:	83 f8 01             	cmp    $0x1,%eax
     5b9:	83 55 cc 00          	adcl   $0x0,-0x34(%ebp)
     5bd:	31 c0                	xor    %eax,%eax
     5bf:	f3 ab                	rep stos %eax,%es:(%edi)
     5c1:	46                   	inc    %esi
     5c2:	8b 45 c0             	mov    -0x40(%ebp),%eax
     5c5:	3b 30                	cmp    (%eax),%esi
     5c7:	72 d1                	jb     59a <regdom_intersect+0x51>
     5c9:	ff 45 c8             	incl   -0x38(%ebp)
     5cc:	8b 55 c4             	mov    -0x3c(%ebp),%edx
     5cf:	8b 4d c8             	mov    -0x38(%ebp),%ecx
     5d2:	3b 0a                	cmp    (%edx),%ecx
     5d4:	72 b2                	jb     588 <regdom_intersect+0x3f>
     5d6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
     5da:	0f 84 85 00 00 00    	je     665 <regdom_intersect+0x11c>
     5e0:	8b 45 cc             	mov    -0x34(%ebp),%eax
     5e3:	ba d0 80 00 00       	mov    $0x80d0,%edx
     5e8:	40                   	inc    %eax
     5e9:	6b c0 18             	imul   $0x18,%eax,%eax
     5ec:	83 c0 08             	add    $0x8,%eax
     5ef:	e8 fc ff ff ff       	call   5f0 <regdom_intersect+0xa7>
     5f4:	85 c0                	test   %eax,%eax
     5f6:	89 c7                	mov    %eax,%edi
     5f8:	74 6b                	je     665 <regdom_intersect+0x11c>
     5fa:	31 f6                	xor    %esi,%esi
     5fc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
     603:	eb 3c                	jmp    641 <regdom_intersect+0xf8>
     605:	6b 45 d8 18          	imul   $0x18,-0x28(%ebp),%eax
     609:	31 db                	xor    %ebx,%ebx
     60b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
     60e:	8d 44 02 08          	lea    0x8(%edx,%eax,1),%eax
     612:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     615:	eb 20                	jmp    637 <regdom_intersect+0xee>
     617:	6b c3 18             	imul   $0x18,%ebx,%eax
     61a:	8b 4d c0             	mov    -0x40(%ebp),%ecx
     61d:	8d 54 01 08          	lea    0x8(%ecx,%eax,1),%edx
     621:	6b c6 18             	imul   $0x18,%esi,%eax
     624:	8d 4c 07 08          	lea    0x8(%edi,%eax,1),%ecx
     628:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     62b:	e8 be fa ff ff       	call   ee <reg_rules_intersect>
     630:	83 f8 01             	cmp    $0x1,%eax
     633:	83 d6 00             	adc    $0x0,%esi
     636:	43                   	inc    %ebx
     637:	8b 45 c0             	mov    -0x40(%ebp),%eax
     63a:	3b 18                	cmp    (%eax),%ebx
     63c:	72 d9                	jb     617 <regdom_intersect+0xce>
     63e:	ff 45 d8             	incl   -0x28(%ebp)
     641:	8b 55 c4             	mov    -0x3c(%ebp),%edx
     644:	8b 4d d8             	mov    -0x28(%ebp),%ecx
     647:	3b 0a                	cmp    (%edx),%ecx
     649:	72 ba                	jb     605 <regdom_intersect+0xbc>
     64b:	3b 75 cc             	cmp    -0x34(%ebp),%esi
     64e:	74 09                	je     659 <regdom_intersect+0x110>
     650:	89 f8                	mov    %edi,%eax
     652:	e8 fc ff ff ff       	call   653 <regdom_intersect+0x10a>
     657:	eb 0c                	jmp    665 <regdom_intersect+0x11c>
     659:	89 37                	mov    %esi,(%edi)
     65b:	c6 47 04 39          	movb   $0x39,0x4(%edi)
     65f:	c6 47 05 38          	movb   $0x38,0x5(%edi)
     663:	eb 02                	jmp    667 <regdom_intersect+0x11e>
     665:	31 ff                	xor    %edi,%edi
     667:	83 c4 34             	add    $0x34,%esp
     66a:	89 f8                	mov    %edi,%eax
     66c:	5b                   	pop    %ebx
     66d:	5e                   	pop    %esi
     66e:	5f                   	pop    %edi
     66f:	5d                   	pop    %ebp
     670:	c3                   	ret    

00000671 <print_rd_rules>:
     671:	55                   	push   %ebp
     672:	89 e5                	mov    %esp,%ebp
     674:	57                   	push   %edi
     675:	89 c7                	mov    %eax,%edi
     677:	56                   	push   %esi
     678:	31 f6                	xor    %esi,%esi
     67a:	53                   	push   %ebx
     67b:	68 27 00 00 00       	push   $0x27
     680:	e8 fc ff ff ff       	call   681 <print_rd_rules+0x10>
     685:	8d 5f 18             	lea    0x18(%edi),%ebx
     688:	58                   	pop    %eax
     689:	eb 3e                	jmp    6c9 <print_rd_rules+0x58>
     68b:	8b 43 fc             	mov    -0x4(%ebx),%eax
     68e:	85 c0                	test   %eax,%eax
     690:	74 1b                	je     6ad <print_rd_rules+0x3c>
     692:	ff 33                	pushl  (%ebx)
     694:	50                   	push   %eax
     695:	ff 73 f8             	pushl  -0x8(%ebx)
     698:	ff 73 f4             	pushl  -0xc(%ebx)
     69b:	ff 73 f0             	pushl  -0x10(%ebx)
     69e:	68 6e 00 00 00       	push   $0x6e
     6a3:	e8 fc ff ff ff       	call   6a4 <print_rd_rules+0x33>
     6a8:	83 c4 18             	add    $0x18,%esp
     6ab:	eb 18                	jmp    6c5 <print_rd_rules+0x54>
     6ad:	ff 33                	pushl  (%ebx)
     6af:	ff 73 f8             	pushl  -0x8(%ebx)
     6b2:	ff 73 f4             	pushl  -0xc(%ebx)
     6b5:	ff 73 f0             	pushl  -0x10(%ebx)
     6b8:	68 a0 00 00 00       	push   $0xa0
     6bd:	e8 fc ff ff ff       	call   6be <print_rd_rules+0x4d>
     6c2:	83 c4 14             	add    $0x14,%esp
     6c5:	46                   	inc    %esi
     6c6:	83 c3 18             	add    $0x18,%ebx
     6c9:	3b 37                	cmp    (%edi),%esi
     6cb:	72 be                	jb     68b <print_rd_rules+0x1a>
     6cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
     6d0:	5b                   	pop    %ebx
     6d1:	5e                   	pop    %esi
     6d2:	5f                   	pop    %edi
     6d3:	5d                   	pop    %ebp
     6d4:	c3                   	ret    

000006d5 <print_regdomain_info>:
     6d5:	55                   	push   %ebp
     6d6:	89 e5                	mov    %esp,%ebp
     6d8:	53                   	push   %ebx
     6d9:	89 c3                	mov    %eax,%ebx
     6db:	0f be 40 05          	movsbl 0x5(%eax),%eax
     6df:	50                   	push   %eax
     6e0:	0f be 43 04          	movsbl 0x4(%ebx),%eax
     6e4:	50                   	push   %eax
     6e5:	68 cf 00 00 00       	push   $0xcf
     6ea:	e8 fc ff ff ff       	call   6eb <print_regdomain_info+0x16>
     6ef:	89 d8                	mov    %ebx,%eax
     6f1:	e8 7b ff ff ff       	call   671 <print_rd_rules>
     6f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     6f9:	83 c4 0c             	add    $0xc,%esp
     6fc:	c9                   	leave  
     6fd:	c3                   	ret    

000006fe <handle_reg_beacon>:
     6fe:	55                   	push   %ebp
     6ff:	89 e5                	mov    %esp,%ebp
     701:	57                   	push   %edi
     702:	89 c7                	mov    %eax,%edi
     704:	56                   	push   %esi
     705:	89 d6                	mov    %edx,%esi
     707:	53                   	push   %ebx
     708:	89 cb                	mov    %ecx,%ebx
     70a:	83 ec 28             	sub    $0x28,%esp
     70d:	a1 00 00 00 00       	mov    0x0,%eax
     712:	48                   	dec    %eax
     713:	75 11                	jne    726 <handle_reg_beacon+0x28>
     715:	6a 00                	push   $0x0
     717:	6a 4e                	push   $0x4e
     719:	68 13 00 00 00       	push   $0x13
     71e:	e8 fc ff ff ff       	call   71f <handle_reg_beacon+0x21>
     723:	83 c4 0c             	add    $0xc,%esp
     726:	8b 43 08             	mov    0x8(%ebx),%eax
     729:	6b ce 28             	imul   $0x28,%esi,%ecx
     72c:	8b 44 87 24          	mov    0x24(%edi,%eax,4),%eax
     730:	03 08                	add    (%eax),%ecx
     732:	8b 41 04             	mov    0x4(%ecx),%eax
     735:	66 3b 43 0c          	cmp    0xc(%ebx),%ax
     739:	75 50                	jne    78b <handle_reg_beacon+0x8d>
     73b:	80 79 18 00          	cmpb   $0x0,0x18(%ecx)
     73f:	75 4a                	jne    78b <handle_reg_beacon+0x8d>
     741:	66 89 45 d0          	mov    %ax,-0x30(%ebp)
     745:	8b 41 0c             	mov    0xc(%ecx),%eax
     748:	c6 41 18 01          	movb   $0x1,0x18(%ecx)
     74c:	89 45 d8             	mov    %eax,-0x28(%ebp)
     74f:	8b 41 0c             	mov    0xc(%ecx),%eax
     752:	a8 02                	test   $0x2,%al
     754:	74 10                	je     766 <handle_reg_beacon+0x68>
     756:	f6 41 1c 02          	testb  $0x2,0x1c(%ecx)
     75a:	75 0a                	jne    766 <handle_reg_beacon+0x68>
     75c:	83 e0 fd             	and    $0xfffffffd,%eax
     75f:	b2 01                	mov    $0x1,%dl
     761:	89 41 0c             	mov    %eax,0xc(%ecx)
     764:	eb 02                	jmp    768 <handle_reg_beacon+0x6a>
     766:	31 d2                	xor    %edx,%edx
     768:	8b 41 0c             	mov    0xc(%ecx),%eax
     76b:	a8 04                	test   $0x4,%al
     76d:	74 0e                	je     77d <handle_reg_beacon+0x7f>
     76f:	f6 41 1c 04          	testb  $0x4,0x1c(%ecx)
     773:	75 08                	jne    77d <handle_reg_beacon+0x7f>
     775:	83 e0 fb             	and    $0xfffffffb,%eax
     778:	89 41 0c             	mov    %eax,0xc(%ecx)
     77b:	eb 04                	jmp    781 <handle_reg_beacon+0x83>
     77d:	84 d2                	test   %dl,%dl
     77f:	74 0a                	je     78b <handle_reg_beacon+0x8d>
     781:	8d 55 cc             	lea    -0x34(%ebp),%edx
     784:	89 f8                	mov    %edi,%eax
     786:	e8 fc ff ff ff       	call   787 <handle_reg_beacon+0x89>
     78b:	8d 65 f4             	lea    -0xc(%ebp),%esp
     78e:	5b                   	pop    %ebx
     78f:	5e                   	pop    %esi
     790:	5f                   	pop    %edi
     791:	5d                   	pop    %ebp
     792:	c3                   	ret    

00000793 <wiphy_update_regulatory>:
     793:	55                   	push   %ebp
     794:	89 e5                	mov    %esp,%ebp
     796:	57                   	push   %edi
     797:	56                   	push   %esi
     798:	53                   	push   %ebx
     799:	83 ec 44             	sub    $0x44,%esp
     79c:	89 45 b8             	mov    %eax,-0x48(%ebp)
     79f:	a1 04 00 00 00       	mov    0x4,%eax
     7a4:	85 c0                	test   %eax,%eax
     7a6:	0f 84 c4 01 00 00    	je     970 <wiphy_update_regulatory+0x1dd>
     7ac:	85 d2                	test   %edx,%edx
     7ae:	75 0d                	jne    7bd <wiphy_update_regulatory+0x2a>
     7b0:	8b 55 b8             	mov    -0x48(%ebp),%edx
     7b3:	80 7a 08 00          	cmpb   $0x0,0x8(%edx)
     7b7:	0f 85 b3 01 00 00    	jne    970 <wiphy_update_regulatory+0x1dd>
     7bd:	8b 4d b8             	mov    -0x48(%ebp),%ecx
     7c0:	80 79 09 00          	cmpb   $0x0,0x9(%ecx)
     7c4:	74 16                	je     7dc <wiphy_update_regulatory+0x49>
     7c6:	83 79 30 00          	cmpl   $0x0,0x30(%ecx)
     7ca:	75 10                	jne    7dc <wiphy_update_regulatory+0x49>
     7cc:	83 c0 08             	add    $0x8,%eax
     7cf:	e8 fc ff ff ff       	call   7d0 <wiphy_update_regulatory+0x3d>
     7d4:	84 c0                	test   %al,%al
     7d6:	0f 84 94 01 00 00    	je     970 <wiphy_update_regulatory+0x1dd>
     7dc:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
     7e3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     7ea:	8b 45 c0             	mov    -0x40(%ebp),%eax
     7ed:	8b 55 b8             	mov    -0x48(%ebp),%edx
     7f0:	8b 44 82 24          	mov    0x24(%edx,%eax,4),%eax
     7f4:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
     7fb:	85 c0                	test   %eax,%eax
     7fd:	89 45 bc             	mov    %eax,-0x44(%ebp)
     800:	0f 85 4b 01 00 00    	jne    951 <wiphy_update_regulatory+0x1be>
     806:	e9 55 01 00 00       	jmp    960 <wiphy_update_regulatory+0x1cd>
     80b:	a1 00 00 00 00       	mov    0x0,%eax
     810:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     817:	48                   	dec    %eax
     818:	75 11                	jne    82b <wiphy_update_regulatory+0x98>
     81a:	6a 00                	push   $0x0
     81c:	6a 4e                	push   $0x4e
     81e:	68 13 00 00 00       	push   $0x13
     823:	e8 fc ff ff ff       	call   824 <wiphy_update_regulatory+0x91>
     828:	83 c4 0c             	add    $0xc,%esp
     82b:	a1 04 00 00 00       	mov    0x4,%eax
     830:	8b 00                	mov    (%eax),%eax
     832:	e8 fc ff ff ff       	call   833 <wiphy_update_regulatory+0xa0>
     837:	8b 55 c0             	mov    -0x40(%ebp),%edx
     83a:	8b 4d b8             	mov    -0x48(%ebp),%ecx
     83d:	89 45 c8             	mov    %eax,-0x38(%ebp)
     840:	8b 44 91 24          	mov    0x24(%ecx,%edx,4),%eax
     844:	8b 55 c4             	mov    -0x3c(%ebp),%edx
     847:	3b 50 0c             	cmp    0xc(%eax),%edx
     84a:	72 04                	jb     850 <wiphy_update_regulatory+0xbd>
     84c:	0f 0b                	ud2a   
     84e:	eb fe                	jmp    84e <wiphy_update_regulatory+0xbb>
     850:	6b 5d c4 28          	imul   $0x28,-0x3c(%ebp),%ebx
     854:	03 18                	add    (%eax),%ebx
     856:	8d 45 f0             	lea    -0x10(%ebp),%eax
     859:	8b 4b 1c             	mov    0x1c(%ebx),%ecx
     85c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
     85f:	b9 20 4e 00 00       	mov    $0x4e20,%ecx
     864:	0f b7 53 04          	movzwl 0x4(%ebx),%edx
     868:	50                   	push   %eax
     869:	8b 45 b8             	mov    -0x48(%ebp),%eax
     86c:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
     872:	e8 fc ff ff ff       	call   873 <wiphy_update_regulatory+0xe0>
     877:	5a                   	pop    %edx
     878:	85 c0                	test   %eax,%eax
     87a:	74 23                	je     89f <wiphy_update_regulatory+0x10c>
     87c:	83 f8 de             	cmp    $0xffffffde,%eax
     87f:	75 0f                	jne    890 <wiphy_update_regulatory+0xfd>
     881:	a1 04 00 00 00       	mov    0x4,%eax
     886:	83 78 04 03          	cmpl   $0x3,0x4(%eax)
     88a:	0f 84 be 00 00 00    	je     94e <wiphy_update_regulatory+0x1bb>
     890:	83 4d cc 01          	orl    $0x1,-0x34(%ebp)
     894:	8b 55 cc             	mov    -0x34(%ebp),%edx
     897:	89 53 0c             	mov    %edx,0xc(%ebx)
     89a:	e9 af 00 00 00       	jmp    94e <wiphy_update_regulatory+0x1bb>
     89f:	8b 7d f0             	mov    -0x10(%ebp),%edi
     8a2:	a1 04 00 00 00       	mov    0x4,%eax
     8a7:	81 7f 08 40 9c 00 00 	cmpl   $0x9c40,0x8(%edi)
     8ae:	19 f6                	sbb    %esi,%esi
     8b0:	83 e6 30             	and    $0x30,%esi
     8b3:	83 78 04 02          	cmpl   $0x2,0x4(%eax)
     8b7:	75 46                	jne    8ff <wiphy_update_regulatory+0x16c>
     8b9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
     8bd:	74 40                	je     8ff <wiphy_update_regulatory+0x16c>
     8bf:	8b 4d b8             	mov    -0x48(%ebp),%ecx
     8c2:	39 4d c8             	cmp    %ecx,-0x38(%ebp)
     8c5:	75 38                	jne    8ff <wiphy_update_regulatory+0x16c>
     8c7:	80 79 09 00          	cmpb   $0x0,0x9(%ecx)
     8cb:	74 32                	je     8ff <wiphy_update_regulatory+0x16c>
     8cd:	8b 47 14             	mov    0x14(%edi),%eax
     8d0:	e8 87 f8 ff ff       	call   15c <map_regdom_flags>
     8d5:	31 d2                	xor    %edx,%edx
     8d7:	09 f0                	or     %esi,%eax
     8d9:	be 64 00 00 00       	mov    $0x64,%esi
     8de:	89 43 1c             	mov    %eax,0x1c(%ebx)
     8e1:	89 43 0c             	mov    %eax,0xc(%ebx)
     8e4:	8b 47 0c             	mov    0xc(%edi),%eax
     8e7:	c6 43 06 14          	movb   $0x14,0x6(%ebx)
     8eb:	f7 f6                	div    %esi
     8ed:	31 d2                	xor    %edx,%edx
     8ef:	89 43 20             	mov    %eax,0x20(%ebx)
     8f2:	89 43 10             	mov    %eax,0x10(%ebx)
     8f5:	8b 47 10             	mov    0x10(%edi),%eax
     8f8:	f7 f6                	div    %esi
     8fa:	89 43 24             	mov    %eax,0x24(%ebx)
     8fd:	eb 4c                	jmp    94b <wiphy_update_regulatory+0x1b8>
     8ff:	8b 47 14             	mov    0x14(%edi),%eax
     902:	e8 55 f8 ff ff       	call   15c <map_regdom_flags>
     907:	31 d2                	xor    %edx,%edx
     909:	09 45 cc             	or     %eax,-0x34(%ebp)
     90c:	0b 75 cc             	or     -0x34(%ebp),%esi
     90f:	89 73 0c             	mov    %esi,0xc(%ebx)
     912:	be 64 00 00 00       	mov    $0x64,%esi
     917:	8b 4f 0c             	mov    0xc(%edi),%ecx
     91a:	c6 43 06 14          	movb   $0x14,0x6(%ebx)
     91e:	89 c8                	mov    %ecx,%eax
     920:	f7 f6                	div    %esi
     922:	89 c1                	mov    %eax,%ecx
     924:	8b 43 20             	mov    0x20(%ebx),%eax
     927:	39 c1                	cmp    %eax,%ecx
     929:	0f 4e c1             	cmovle %ecx,%eax
     92c:	8b 4b 24             	mov    0x24(%ebx),%ecx
     92f:	89 43 10             	mov    %eax,0x10(%ebx)
     932:	8b 47 10             	mov    0x10(%edi),%eax
     935:	85 c9                	test   %ecx,%ecx
     937:	74 0e                	je     947 <wiphy_update_regulatory+0x1b4>
     939:	31 d2                	xor    %edx,%edx
     93b:	f7 f6                	div    %esi
     93d:	39 c8                	cmp    %ecx,%eax
     93f:	0f 4e c8             	cmovle %eax,%ecx
     942:	89 4b 14             	mov    %ecx,0x14(%ebx)
     945:	eb 07                	jmp    94e <wiphy_update_regulatory+0x1bb>
     947:	31 d2                	xor    %edx,%edx
     949:	f7 f6                	div    %esi
     94b:	89 43 14             	mov    %eax,0x14(%ebx)
     94e:	ff 45 c4             	incl   -0x3c(%ebp)
     951:	8b 4d bc             	mov    -0x44(%ebp),%ecx
     954:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     957:	3b 41 0c             	cmp    0xc(%ecx),%eax
     95a:	0f 82 ab fe ff ff    	jb     80b <wiphy_update_regulatory+0x78>
     960:	ff 45 ec             	incl   -0x14(%ebp)
     963:	ff 45 c0             	incl   -0x40(%ebp)
     966:	83 7d ec 02          	cmpl   $0x2,-0x14(%ebp)
     96a:	0f 85 7a fe ff ff    	jne    7ea <wiphy_update_regulatory+0x57>
     970:	8b 1d 04 00 00 00    	mov    0x4,%ebx
     976:	85 db                	test   %ebx,%ebx
     978:	0f 84 93 00 00 00    	je     a11 <wiphy_update_regulatory+0x27e>
     97e:	a1 00 00 00 00       	mov    0x0,%eax
     983:	83 c0 04             	add    $0x4,%eax
     986:	e8 fc ff ff ff       	call   987 <wiphy_update_regulatory+0x1f4>
     98b:	84 c0                	test   %al,%al
     98d:	75 25                	jne    9b4 <wiphy_update_regulatory+0x221>
     98f:	8b 55 b8             	mov    -0x48(%ebp),%edx
     992:	8b 42 30             	mov    0x30(%edx),%eax
     995:	85 c0                	test   %eax,%eax
     997:	74 0c                	je     9a5 <wiphy_update_regulatory+0x212>
     999:	83 c0 04             	add    $0x4,%eax
     99c:	e8 fc ff ff ff       	call   99d <wiphy_update_regulatory+0x20a>
     9a1:	84 c0                	test   %al,%al
     9a3:	75 0f                	jne    9b4 <wiphy_update_regulatory+0x221>
     9a5:	83 7b 04 03          	cmpl   $0x3,0x4(%ebx)
     9a9:	74 66                	je     a11 <wiphy_update_regulatory+0x27e>
     9ab:	8b 4d b8             	mov    -0x48(%ebp),%ecx
     9ae:	80 79 08 00          	cmpb   $0x0,0x8(%ecx)
     9b2:	74 5d                	je     a11 <wiphy_update_regulatory+0x27e>
     9b4:	a1 00 00 00 00       	mov    0x0,%eax
     9b9:	48                   	dec    %eax
     9ba:	75 11                	jne    9cd <wiphy_update_regulatory+0x23a>
     9bc:	6a 00                	push   $0x0
     9be:	6a 4e                	push   $0x4e
     9c0:	68 13 00 00 00       	push   $0x13
     9c5:	e8 fc ff ff ff       	call   9c6 <wiphy_update_regulatory+0x233>
     9ca:	83 c4 0c             	add    $0xc,%esp
     9cd:	8b 1d 1c 00 00 00    	mov    0x1c,%ebx
     9d3:	81 fb 1c 00 00 00    	cmp    $0x1c,%ebx
     9d9:	75 28                	jne    a03 <wiphy_update_regulatory+0x270>
     9db:	eb 34                	jmp    a11 <wiphy_update_regulatory+0x27e>
     9dd:	8b 43 08             	mov    0x8(%ebx),%eax
     9e0:	31 f6                	xor    %esi,%esi
     9e2:	8b 55 b8             	mov    -0x48(%ebp),%edx
     9e5:	8b 7c 82 24          	mov    0x24(%edx,%eax,4),%edi
     9e9:	85 ff                	test   %edi,%edi
     9eb:	75 0f                	jne    9fc <wiphy_update_regulatory+0x269>
     9ed:	eb 12                	jmp    a01 <wiphy_update_regulatory+0x26e>
     9ef:	8b 45 b8             	mov    -0x48(%ebp),%eax
     9f2:	89 f2                	mov    %esi,%edx
     9f4:	89 d9                	mov    %ebx,%ecx
     9f6:	46                   	inc    %esi
     9f7:	e8 02 fd ff ff       	call   6fe <handle_reg_beacon>
     9fc:	3b 77 0c             	cmp    0xc(%edi),%esi
     9ff:	72 ee                	jb     9ef <wiphy_update_regulatory+0x25c>
     a01:	8b 1b                	mov    (%ebx),%ebx
     a03:	8b 03                	mov    (%ebx),%eax
     a05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     a09:	81 fb 1c 00 00 00    	cmp    $0x1c,%ebx
     a0f:	75 cc                	jne    9dd <wiphy_update_regulatory+0x24a>
     a11:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
     a15:	0f 84 fa 00 00 00    	je     b15 <wiphy_update_regulatory+0x382>
     a1b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
     a22:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
     a29:	8b 4d d8             	mov    -0x28(%ebp),%ecx
     a2c:	8b 45 b8             	mov    -0x48(%ebp),%eax
     a2f:	8b 4c 88 24          	mov    0x24(%eax,%ecx,4),%ecx
     a33:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     a3a:	85 c9                	test   %ecx,%ecx
     a3c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
     a3f:	0f 85 b1 00 00 00    	jne    af6 <wiphy_update_regulatory+0x363>
     a45:	e9 bb 00 00 00       	jmp    b05 <wiphy_update_regulatory+0x372>
     a4a:	a1 00 00 00 00       	mov    0x0,%eax
     a4f:	48                   	dec    %eax
     a50:	75 11                	jne    a63 <wiphy_update_regulatory+0x2d0>
     a52:	6a 00                	push   $0x0
     a54:	6a 4e                	push   $0x4e
     a56:	68 13 00 00 00       	push   $0x13
     a5b:	e8 fc ff ff ff       	call   a5c <wiphy_update_regulatory+0x2c9>
     a60:	83 c4 0c             	add    $0xc,%esp
     a63:	8b 55 d8             	mov    -0x28(%ebp),%edx
     a66:	8b 4d b8             	mov    -0x48(%ebp),%ecx
     a69:	8b 44 91 24          	mov    0x24(%ecx,%edx,4),%eax
     a6d:	8b 50 0c             	mov    0xc(%eax),%edx
     a70:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
     a73:	89 55 e4             	mov    %edx,-0x1c(%ebp)
     a76:	72 04                	jb     a7c <wiphy_update_regulatory+0x2e9>
     a78:	0f 0b                	ud2a   
     a7a:	eb fe                	jmp    a7a <wiphy_update_regulatory+0x2e7>
     a7c:	8b 30                	mov    (%eax),%esi
     a7e:	6b 45 d4 28          	imul   $0x28,-0x2c(%ebp),%eax
     a82:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
     a85:	89 d8                	mov    %ebx,%eax
     a87:	e8 f9 f7 ff ff       	call   285 <is_ht40_not_allowed>
     a8c:	84 c0                	test   %al,%al
     a8e:	75 04                	jne    a94 <wiphy_update_regulatory+0x301>
     a90:	31 ff                	xor    %edi,%edi
     a92:	eb 2e                	jmp    ac2 <wiphy_update_regulatory+0x32f>
     a94:	83 4b 0c 30          	orl    $0x30,0xc(%ebx)
     a98:	eb 59                	jmp    af3 <wiphy_update_regulatory+0x360>
     a9a:	0f b7 53 04          	movzwl 0x4(%ebx),%edx
     a9e:	0f b7 46 04          	movzwl 0x4(%esi),%eax
     aa2:	8d 4a ec             	lea    -0x14(%edx),%ecx
     aa5:	39 c8                	cmp    %ecx,%eax
     aa7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
     aaa:	0f 44 ce             	cmove  %esi,%ecx
     aad:	83 c2 14             	add    $0x14,%edx
     ab0:	39 d0                	cmp    %edx,%eax
     ab2:	8b 45 dc             	mov    -0x24(%ebp),%eax
     ab5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
     ab8:	0f 44 c6             	cmove  %esi,%eax
     abb:	47                   	inc    %edi
     abc:	89 45 dc             	mov    %eax,-0x24(%ebp)
     abf:	83 c6 28             	add    $0x28,%esi
     ac2:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
     ac5:	75 d3                	jne    a9a <wiphy_update_regulatory+0x307>
     ac7:	8b 45 e0             	mov    -0x20(%ebp),%eax
     aca:	e8 b6 f7 ff ff       	call   285 <is_ht40_not_allowed>
     acf:	84 c0                	test   %al,%al
     ad1:	74 06                	je     ad9 <wiphy_update_regulatory+0x346>
     ad3:	83 4b 0c 20          	orl    $0x20,0xc(%ebx)
     ad7:	eb 04                	jmp    add <wiphy_update_regulatory+0x34a>
     ad9:	83 63 0c df          	andl   $0xffffffdf,0xc(%ebx)
     add:	8b 45 dc             	mov    -0x24(%ebp),%eax
     ae0:	e8 a0 f7 ff ff       	call   285 <is_ht40_not_allowed>
     ae5:	84 c0                	test   %al,%al
     ae7:	74 06                	je     aef <wiphy_update_regulatory+0x35c>
     ae9:	83 4b 0c 10          	orl    $0x10,0xc(%ebx)
     aed:	eb 04                	jmp    af3 <wiphy_update_regulatory+0x360>
     aef:	83 63 0c ef          	andl   $0xffffffef,0xc(%ebx)
     af3:	ff 45 d4             	incl   -0x2c(%ebp)
     af6:	8b 55 d0             	mov    -0x30(%ebp),%edx
     af9:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
     afc:	3b 4a 0c             	cmp    0xc(%edx),%ecx
     aff:	0f 82 45 ff ff ff    	jb     a4a <wiphy_update_regulatory+0x2b7>
     b05:	ff 45 e8             	incl   -0x18(%ebp)
     b08:	ff 45 d8             	incl   -0x28(%ebp)
     b0b:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
     b0f:	0f 85 14 ff ff ff    	jne    a29 <wiphy_update_regulatory+0x296>
     b15:	8b 45 b8             	mov    -0x48(%ebp),%eax
     b18:	8b 48 2c             	mov    0x2c(%eax),%ecx
     b1b:	85 c9                	test   %ecx,%ecx
     b1d:	74 08                	je     b27 <wiphy_update_regulatory+0x394>
     b1f:	8b 15 04 00 00 00    	mov    0x4,%edx
     b25:	ff d1                	call   *%ecx
     b27:	8d 65 f4             	lea    -0xc(%ebp),%esp
     b2a:	5b                   	pop    %ebx
     b2b:	5e                   	pop    %esi
     b2c:	5f                   	pop    %edi
     b2d:	5d                   	pop    %ebp
     b2e:	c3                   	ret    

00000b2f <reg_todo>:
     b2f:	55                   	push   %ebp
     b30:	89 e5                	mov    %esp,%ebp
     b32:	57                   	push   %edi
     b33:	56                   	push   %esi
     b34:	53                   	push   %ebx
     b35:	83 ec 28             	sub    $0x28,%esp
     b38:	e9 c9 02 00 00       	jmp    e06 <reg_todo+0x2d7>
     b3d:	8d 73 ec             	lea    -0x14(%ebx),%esi
     b40:	8b 46 18             	mov    0x18(%esi),%eax
     b43:	8b 56 14             	mov    0x14(%esi),%edx
     b46:	89 42 04             	mov    %eax,0x4(%edx)
     b49:	89 10                	mov    %edx,(%eax)
     b4b:	b8 00 00 00 00       	mov    $0x0,%eax
     b50:	89 5e 14             	mov    %ebx,0x14(%esi)
     b53:	89 5e 18             	mov    %ebx,0x18(%esi)
     b56:	e8 fc ff ff ff       	call   b57 <reg_todo+0x28>
     b5b:	8b 43 ec             	mov    -0x14(%ebx),%eax
     b5e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
     b65:	85 c0                	test   %eax,%eax
     b67:	78 08                	js     b71 <reg_todo+0x42>
     b69:	e8 fc ff ff ff       	call   b6a <reg_todo+0x3b>
     b6e:	89 45 d0             	mov    %eax,-0x30(%ebp)
     b71:	83 7e 04 02          	cmpl   $0x2,0x4(%esi)
     b75:	75 12                	jne    b89 <reg_todo+0x5a>
     b77:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
     b7b:	75 0c                	jne    b89 <reg_todo+0x5a>
     b7d:	89 f0                	mov    %esi,%eax
     b7f:	e8 fc ff ff ff       	call   b80 <reg_todo+0x51>
     b84:	e9 73 02 00 00       	jmp    dfc <reg_todo+0x2cd>
     b89:	a1 00 00 00 00       	mov    0x0,%eax
     b8e:	48                   	dec    %eax
     b8f:	75 11                	jne    ba2 <reg_todo+0x73>
     b91:	6a 00                	push   $0x0
     b93:	6a 4e                	push   $0x4e
     b95:	68 13 00 00 00       	push   $0x13
     b9a:	e8 fc ff ff ff       	call   b9b <reg_todo+0x6c>
     b9f:	83 c4 0c             	add    $0xc,%esp
     ba2:	a1 00 00 00 00       	mov    0x0,%eax
     ba7:	48                   	dec    %eax
     ba8:	75 11                	jne    bbb <reg_todo+0x8c>
     baa:	6a 00                	push   $0x0
     bac:	6a 4e                	push   $0x4e
     bae:	68 13 00 00 00       	push   $0x13
     bb3:	e8 fc ff ff ff       	call   bb4 <reg_todo+0x85>
     bb8:	83 c4 0c             	add    $0xc,%esp
     bbb:	a1 04 00 00 00       	mov    0x4,%eax
     bc0:	85 c0                	test   %eax,%eax
     bc2:	0f 84 2c 03 00 00    	je     ef4 <reg_todo+0x3c5>
     bc8:	8b 56 04             	mov    0x4(%esi),%edx
     bcb:	83 fa 02             	cmp    $0x2,%edx
     bce:	0f 84 81 00 00 00    	je     c55 <reg_todo+0x126>
     bd4:	83 fa 03             	cmp    $0x3,%edx
     bd7:	74 11                	je     bea <reg_todo+0xbb>
     bd9:	4a                   	dec    %edx
     bda:	bb ea ff ff ff       	mov    $0xffffffea,%ebx
     bdf:	0f 85 4b 01 00 00    	jne    d30 <reg_todo+0x201>
     be5:	e9 98 00 00 00       	jmp    c82 <reg_todo+0x153>
     bea:	8b 00                	mov    (%eax),%eax
     bec:	8d 5e 08             	lea    0x8(%esi),%ebx
     bef:	e8 fc ff ff ff       	call   bf0 <reg_todo+0xc1>
     bf4:	89 c7                	mov    %eax,%edi
     bf6:	89 d8                	mov    %ebx,%eax
     bf8:	e8 60 f4 ff ff       	call   5d <is_an_alpha2>
     bfd:	84 c0                	test   %al,%al
     bff:	0f 84 12 03 00 00    	je     f17 <reg_todo+0x3e8>
     c05:	a1 04 00 00 00       	mov    0x4,%eax
     c0a:	83 78 04 03          	cmpl   $0x3,0x4(%eax)
     c0e:	0f 85 eb 02 00 00    	jne    eff <reg_todo+0x3d0>
     c14:	3b 7d d0             	cmp    -0x30(%ebp),%edi
     c17:	74 14                	je     c2d <reg_todo+0xfe>
     c19:	89 d8                	mov    %ebx,%eax
     c1b:	e8 1b f8 ff ff       	call   43b <regdom_changes>
     c20:	84 c0                	test   %al,%al
     c22:	0f 85 f9 02 00 00    	jne    f21 <reg_todo+0x3f2>
     c28:	e9 cf 00 00 00       	jmp    cfc <reg_todo+0x1cd>
     c2d:	89 d8                	mov    %ebx,%eax
     c2f:	e8 07 f8 ff ff       	call   43b <regdom_changes>
     c34:	84 c0                	test   %al,%al
     c36:	0f 84 c0 00 00 00    	je     cfc <reg_todo+0x1cd>
     c3c:	6a 00                	push   $0x0
     c3e:	68 8a 05 00 00       	push   $0x58a
     c43:	68 00 00 00 00       	push   $0x0
     c48:	e8 fc ff ff ff       	call   c49 <reg_todo+0x11a>
     c4d:	83 c4 0c             	add    $0xc,%esp
     c50:	e9 9f 02 00 00       	jmp    ef4 <reg_todo+0x3c5>
     c55:	8b 40 04             	mov    0x4(%eax),%eax
     c58:	85 c0                	test   %eax,%eax
     c5a:	75 0c                	jne    c68 <reg_todo+0x139>
     c5c:	a1 00 00 00 00       	mov    0x0,%eax
     c61:	e8 9a f3 ff ff       	call   0 <is_old_static_regdom>
     c66:	eb 5e                	jmp    cc6 <reg_todo+0x197>
     c68:	83 f8 02             	cmp    $0x2,%eax
     c6b:	0f 85 8e 02 00 00    	jne    eff <reg_todo+0x3d0>
     c71:	8d 46 08             	lea    0x8(%esi),%eax
     c74:	e8 c2 f7 ff ff       	call   43b <regdom_changes>
     c79:	84 c0                	test   %al,%al
     c7b:	74 7f                	je     cfc <reg_todo+0x1cd>
     c7d:	e9 7d 02 00 00       	jmp    eff <reg_todo+0x3d0>
     c82:	8b 50 04             	mov    0x4(%eax),%edx
     c85:	83 fa 03             	cmp    $0x3,%edx
     c88:	0f 84 71 02 00 00    	je     eff <reg_todo+0x3d0>
     c8e:	83 fa 01             	cmp    $0x1,%edx
     c91:	75 0c                	jne    c9f <reg_todo+0x170>
     c93:	80 78 0a 00          	cmpb   $0x0,0xa(%eax)
     c97:	0f 85 84 02 00 00    	jne    f21 <reg_todo+0x3f2>
     c9d:	eb 04                	jmp    ca3 <reg_todo+0x174>
     c9f:	85 d2                	test   %edx,%edx
     ca1:	74 08                	je     cab <reg_todo+0x17c>
     ca3:	83 fa 02             	cmp    $0x2,%edx
     ca6:	74 03                	je     cab <reg_todo+0x17c>
     ca8:	4a                   	dec    %edx
     ca9:	75 11                	jne    cbc <reg_todo+0x18d>
     cab:	83 c0 08             	add    $0x8,%eax
     cae:	bb f5 ff ff ff       	mov    $0xfffffff5,%ebx
     cb3:	e8 83 f7 ff ff       	call   43b <regdom_changes>
     cb8:	84 c0                	test   %al,%al
     cba:	75 74                	jne    d30 <reg_todo+0x201>
     cbc:	a1 00 00 00 00       	mov    0x0,%eax
     cc1:	e8 3a f3 ff ff       	call   0 <is_old_static_regdom>
     cc6:	84 c0                	test   %al,%al
     cc8:	0f 85 26 02 00 00    	jne    ef4 <reg_todo+0x3c5>
     cce:	8d 46 08             	lea    0x8(%esi),%eax
     cd1:	e8 65 f7 ff ff       	call   43b <regdom_changes>
     cd6:	84 c0                	test   %al,%al
     cd8:	74 22                	je     cfc <reg_todo+0x1cd>
     cda:	e9 15 02 00 00       	jmp    ef4 <reg_todo+0x3c5>
     cdf:	8b 45 d0             	mov    -0x30(%ebp),%eax
     ce2:	8b 15 00 00 00 00    	mov    0x0,%edx
     ce8:	83 c0 30             	add    $0x30,%eax
     ceb:	e8 ef f7 ff ff       	call   4df <reg_copy_regd>
     cf0:	c6 45 cf 01          	movb   $0x1,-0x31(%ebp)
     cf4:	85 c0                	test   %eax,%eax
     cf6:	89 c3                	mov    %eax,%ebx
     cf8:	74 42                	je     d3c <reg_todo+0x20d>
     cfa:	eb 34                	jmp    d30 <reg_todo+0x201>
     cfc:	83 7e 04 02          	cmpl   $0x2,0x4(%esi)
     d00:	bb 8e ff ff ff       	mov    $0xffffff8e,%ebx
     d05:	75 29                	jne    d30 <reg_todo+0x201>
     d07:	8b 45 d0             	mov    -0x30(%ebp),%eax
     d0a:	8b 15 00 00 00 00    	mov    0x0,%edx
     d10:	83 c0 30             	add    $0x30,%eax
     d13:	e8 c7 f7 ff ff       	call   4df <reg_copy_regd>
     d18:	c6 45 cf 00          	movb   $0x0,-0x31(%ebp)
     d1c:	85 c0                	test   %eax,%eax
     d1e:	89 c7                	mov    %eax,%edi
     d20:	74 1a                	je     d3c <reg_todo+0x20d>
     d22:	89 f0                	mov    %esi,%eax
     d24:	89 fb                	mov    %edi,%ebx
     d26:	e8 fc ff ff ff       	call   d27 <reg_todo+0x1f8>
     d2b:	e9 b0 00 00 00       	jmp    de0 <reg_todo+0x2b1>
     d30:	89 f0                	mov    %esi,%eax
     d32:	e8 fc ff ff ff       	call   d33 <reg_todo+0x204>
     d37:	e9 a4 00 00 00       	jmp    de0 <reg_todo+0x2b1>
     d3c:	a1 04 00 00 00       	mov    0x4,%eax
     d41:	e8 fc ff ff ff       	call   d42 <reg_todo+0x213>
     d46:	8a 45 cf             	mov    -0x31(%ebp),%al
     d49:	85 db                	test   %ebx,%ebx
     d4b:	89 35 04 00 00 00    	mov    %esi,0x4
     d51:	88 46 0a             	mov    %al,0xa(%esi)
     d54:	79 12                	jns    d68 <reg_todo+0x239>
     d56:	83 fb 8e             	cmp    $0xffffff8e,%ebx
     d59:	0f 85 9d 00 00 00    	jne    dfc <reg_todo+0x2cd>
     d5f:	89 f0                	mov    %esi,%eax
     d61:	e8 fc ff ff ff       	call   d62 <reg_todo+0x233>
     d66:	eb 7d                	jmp    de5 <reg_todo+0x2b6>
     d68:	b9 09 00 00 00       	mov    $0x9,%ecx
     d6d:	ba 00 00 00 00       	mov    $0x0,%edx
     d72:	8d 45 e1             	lea    -0x1f(%ebp),%eax
     d75:	e8 fc ff ff ff       	call   d76 <reg_todo+0x247>
     d7a:	8d 45 e1             	lea    -0x1f(%ebp),%eax
     d7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
     d80:	8d 46 08             	lea    0x8(%esi),%eax
     d83:	66 c7 45 ea 00 00    	movw   $0x0,-0x16(%ebp)
     d89:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     d90:	e8 fc ff ff ff       	call   d91 <reg_todo+0x262>
     d95:	84 c0                	test   %al,%al
     d97:	75 19                	jne    db2 <reg_todo+0x283>
     d99:	0f be 46 09          	movsbl 0x9(%esi),%eax
     d9d:	50                   	push   %eax
     d9e:	0f be 46 08          	movsbl 0x8(%esi),%eax
     da2:	50                   	push   %eax
     da3:	68 f5 00 00 00       	push   $0xf5
     da8:	e8 fc ff ff ff       	call   da9 <reg_todo+0x27a>
     dad:	83 c4 0c             	add    $0xc,%esp
     db0:	eb 0b                	jmp    dbd <reg_todo+0x28e>
     db2:	68 22 01 00 00       	push   $0x122
     db7:	e8 fc ff ff ff       	call   db8 <reg_todo+0x289>
     dbc:	59                   	pop    %ecx
     dbd:	8a 46 08             	mov    0x8(%esi),%al
     dc0:	8d 4d ec             	lea    -0x14(%ebp),%ecx
     dc3:	ba 02 00 00 00       	mov    $0x2,%edx
     dc8:	88 45 e9             	mov    %al,-0x17(%ebp)
     dcb:	8a 46 09             	mov    0x9(%esi),%al
     dce:	88 45 ea             	mov    %al,-0x16(%ebp)
     dd1:	a1 08 00 00 00       	mov    0x8,%eax
     dd6:	83 c0 10             	add    $0x10,%eax
     dd9:	e8 fc ff ff ff       	call   dda <reg_todo+0x2ab>
     dde:	89 c3                	mov    %eax,%ebx
     de0:	83 fb 8e             	cmp    $0xffffff8e,%ebx
     de3:	75 17                	jne    dfc <reg_todo+0x2cd>
     de5:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
     de9:	74 11                	je     dfc <reg_todo+0x2cd>
     deb:	8b 45 d0             	mov    -0x30(%ebp),%eax
     dee:	80 78 09 00          	cmpb   $0x0,0x9(%eax)
     df2:	74 08                	je     dfc <reg_todo+0x2cd>
     df4:	8b 56 04             	mov    0x4(%esi),%edx
     df7:	e8 fc ff ff ff       	call   df8 <reg_todo+0x2c9>
     dfc:	b8 00 00 00 00       	mov    $0x0,%eax
     e01:	e8 fc ff ff ff       	call   e02 <reg_todo+0x2d3>
     e06:	8b 1d 24 00 00 00    	mov    0x24,%ebx
     e0c:	81 fb 24 00 00 00    	cmp    $0x24,%ebx
     e12:	0f 85 25 fd ff ff    	jne    b3d <reg_todo+0xe>
     e18:	b8 00 00 00 00       	mov    $0x0,%eax
     e1d:	e8 fc ff ff ff       	call   e1e <reg_todo+0x2ef>
     e22:	e8 fc ff ff ff       	call   e23 <reg_todo+0x2f4>
     e27:	a1 14 00 00 00       	mov    0x14,%eax
     e2c:	3d 14 00 00 00       	cmp    $0x14,%eax
     e31:	89 c3                	mov    %eax,%ebx
     e33:	0f 85 93 00 00 00    	jne    ecc <reg_todo+0x39d>
     e39:	e9 9f 00 00 00       	jmp    edd <reg_todo+0x3ae>
     e3e:	8b 13                	mov    (%ebx),%edx
     e40:	8b 43 04             	mov    0x4(%ebx),%eax
     e43:	89 10                	mov    %edx,(%eax)
     e45:	89 1b                	mov    %ebx,(%ebx)
     e47:	8b 35 00 00 00 00    	mov    0x0,%esi
     e4d:	89 42 04             	mov    %eax,0x4(%edx)
     e50:	89 5b 04             	mov    %ebx,0x4(%ebx)
     e53:	eb 4c                	jmp    ea1 <reg_todo+0x372>
     e55:	8d 46 60             	lea    0x60(%esi),%eax
     e58:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     e5b:	a1 00 00 00 00       	mov    0x0,%eax
     e60:	48                   	dec    %eax
     e61:	75 11                	jne    e74 <reg_todo+0x345>
     e63:	6a 00                	push   $0x0
     e65:	6a 4e                	push   $0x4e
     e67:	68 13 00 00 00       	push   $0x13
     e6c:	e8 fc ff ff ff       	call   e6d <reg_todo+0x33e>
     e71:	83 c4 0c             	add    $0xc,%esp
     e74:	8b 43 08             	mov    0x8(%ebx),%eax
     e77:	31 ff                	xor    %edi,%edi
     e79:	8b 84 86 84 00 00 00 	mov    0x84(%esi,%eax,4),%eax
     e80:	85 c0                	test   %eax,%eax
     e82:	89 45 d8             	mov    %eax,-0x28(%ebp)
     e85:	75 0f                	jne    e96 <reg_todo+0x367>
     e87:	eb 15                	jmp    e9e <reg_todo+0x36f>
     e89:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     e8c:	89 fa                	mov    %edi,%edx
     e8e:	89 d9                	mov    %ebx,%ecx
     e90:	47                   	inc    %edi
     e91:	e8 68 f8 ff ff       	call   6fe <handle_reg_beacon>
     e96:	8b 45 d8             	mov    -0x28(%ebp),%eax
     e99:	3b 78 0c             	cmp    0xc(%eax),%edi
     e9c:	72 eb                	jb     e89 <reg_todo+0x35a>
     e9e:	8b 76 04             	mov    0x4(%esi),%esi
     ea1:	83 ee 04             	sub    $0x4,%esi
     ea4:	8b 46 04             	mov    0x4(%esi),%eax
     ea7:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     eab:	81 fe fc ff ff ff    	cmp    $0xfffffffc,%esi
     eb1:	75 a2                	jne    e55 <reg_todo+0x326>
     eb3:	a1 20 00 00 00       	mov    0x20,%eax
     eb8:	c7 03 1c 00 00 00    	movl   $0x1c,(%ebx)
     ebe:	89 1d 20 00 00 00    	mov    %ebx,0x20
     ec4:	89 18                	mov    %ebx,(%eax)
     ec6:	89 43 04             	mov    %eax,0x4(%ebx)
     ec9:	8b 5d dc             	mov    -0x24(%ebp),%ebx
     ecc:	8b 03                	mov    (%ebx),%eax
     ece:	81 fb 14 00 00 00    	cmp    $0x14,%ebx
     ed4:	89 45 dc             	mov    %eax,-0x24(%ebp)
     ed7:	0f 85 61 ff ff ff    	jne    e3e <reg_todo+0x30f>
     edd:	e8 fc ff ff ff       	call   ede <reg_todo+0x3af>
     ee2:	b8 00 00 00 00       	mov    $0x0,%eax
     ee7:	e8 fc ff ff ff       	call   ee8 <reg_todo+0x3b9>
     eec:	8d 65 f4             	lea    -0xc(%ebp),%esp
     eef:	5b                   	pop    %ebx
     ef0:	5e                   	pop    %esi
     ef1:	5f                   	pop    %edi
     ef2:	5d                   	pop    %ebp
     ef3:	c3                   	ret    
     ef4:	31 db                	xor    %ebx,%ebx
     ef6:	c6 45 cf 00          	movb   $0x0,-0x31(%ebp)
     efa:	e9 3d fe ff ff       	jmp    d3c <reg_todo+0x20d>
     eff:	83 7e 04 02          	cmpl   $0x2,0x4(%esi)
     f03:	0f 84 d6 fd ff ff    	je     cdf <reg_todo+0x1b0>
     f09:	bb 01 00 00 00       	mov    $0x1,%ebx
     f0e:	c6 45 cf 01          	movb   $0x1,-0x31(%ebp)
     f12:	e9 25 fe ff ff       	jmp    d3c <reg_todo+0x20d>
     f17:	bb ea ff ff ff       	mov    $0xffffffea,%ebx
     f1c:	e9 0f fe ff ff       	jmp    d30 <reg_todo+0x201>
     f21:	bb a1 ff ff ff       	mov    $0xffffffa1,%ebx
     f26:	e9 05 fe ff ff       	jmp    d30 <reg_todo+0x201>

00000f2b <queue_regulatory_request>:
     f2b:	8b 0d 28 00 00 00    	mov    0x28,%ecx
     f31:	8d 50 14             	lea    0x14(%eax),%edx
     f34:	55                   	push   %ebp
     f35:	89 e5                	mov    %esp,%ebp
     f37:	c7 40 14 24 00 00 00 	movl   $0x24,0x14(%eax)
     f3e:	89 15 28 00 00 00    	mov    %edx,0x28
     f44:	89 11                	mov    %edx,(%ecx)
     f46:	89 48 18             	mov    %ecx,0x18(%eax)
     f49:	b8 04 00 00 00       	mov    $0x4,%eax
     f4e:	e8 fc ff ff ff       	call   f4f <queue_regulatory_request+0x24>
     f53:	5d                   	pop    %ebp
     f54:	c3                   	ret    

00000f55 <regulatory_init>:
     f55:	55                   	push   %ebp
     f56:	31 c9                	xor    %ecx,%ecx
     f58:	89 e5                	mov    %esp,%ebp
     f5a:	31 d2                	xor    %edx,%edx
     f5c:	57                   	push   %edi
     f5d:	b8 5f 01 00 00       	mov    $0x15f,%eax
     f62:	56                   	push   %esi
     f63:	53                   	push   %ebx
     f64:	83 ec 04             	sub    $0x4,%esp
     f67:	6a 00                	push   $0x0
     f69:	e8 fc ff ff ff       	call   f6a <regulatory_init+0x15>
     f6e:	5b                   	pop    %ebx
     f6f:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
     f74:	a3 08 00 00 00       	mov    %eax,0x8
     f79:	0f 87 d9 00 00 00    	ja     1058 <regulatory_init+0x103>
     f7f:	a1 00 00 00 00       	mov    0x0,%eax
     f84:	80 38 55             	cmpb   $0x55,(%eax)
     f87:	75 0b                	jne    f94 <regulatory_init+0x3f>
     f89:	80 78 01 53          	cmpb   $0x53,0x1(%eax)
     f8d:	ba 0c 00 00 00       	mov    $0xc,%edx
     f92:	74 25                	je     fb9 <regulatory_init+0x64>
     f94:	80 38 4a             	cmpb   $0x4a,(%eax)
     f97:	75 0b                	jne    fa4 <regulatory_init+0x4f>
     f99:	80 78 01 50          	cmpb   $0x50,0x1(%eax)
     f9d:	ba a4 00 00 00       	mov    $0xa4,%edx
     fa2:	74 15                	je     fb9 <regulatory_init+0x64>
     fa4:	80 38 45             	cmpb   $0x45,(%eax)
     fa7:	75 0b                	jne    fb4 <regulatory_init+0x5f>
     fa9:	80 78 01 55          	cmpb   $0x55,0x1(%eax)
     fad:	ba f4 00 00 00       	mov    $0xf4,%edx
     fb2:	74 05                	je     fb9 <regulatory_init+0x64>
     fb4:	ba 0c 00 00 00       	mov    $0xc,%edx
     fb9:	68 6a 01 00 00       	push   $0x16a
     fbe:	89 15 00 00 00 00    	mov    %edx,0x0
     fc4:	e8 fc ff ff ff       	call   fc5 <regulatory_init+0x70>
     fc9:	a1 00 00 00 00       	mov    0x0,%eax
     fce:	e8 02 f7 ff ff       	call   6d5 <print_regdomain_info>
     fd3:	a1 00 00 00 00       	mov    0x0,%eax
     fd8:	83 3d 04 00 00 00 00 	cmpl   $0x0,0x4
     fdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
     fe2:	59                   	pop    %ecx
     fe3:	74 04                	je     fe9 <regulatory_init+0x94>
     fe5:	0f 0b                	ud2a   
     fe7:	eb fe                	jmp    fe7 <regulatory_init+0x92>
     fe9:	ba d0 80 00 00       	mov    $0x80d0,%edx
     fee:	b8 e4 02 00 00       	mov    $0x2e4,%eax
     ff3:	e8 fc ff ff ff       	call   ff4 <regulatory_init+0x9f>
     ff8:	8b 3d e8 02 00 00    	mov    0x2e8,%edi
     ffe:	83 3d 04 00 00 00 00 	cmpl   $0x0,0x4
    1005:	89 c6                	mov    %eax,%esi
    1007:	74 28                	je     1031 <regulatory_init+0xdc>
    1009:	8b 1d 08 00 00 00    	mov    0x8,%ebx
    100f:	85 db                	test   %ebx,%ebx
    1011:	74 1e                	je     1031 <regulatory_init+0xdc>
    1013:	68 d0 80 00 00       	push   $0x80d0
    1018:	89 f2                	mov    %esi,%edx
    101a:	b8 e9 0f 00 00       	mov    $0xfe9,%eax
    101f:	b9 1c 00 00 00       	mov    $0x1c,%ecx
    1024:	57                   	push   %edi
    1025:	ff 13                	call   *(%ebx)
    1027:	83 c3 04             	add    $0x4,%ebx
    102a:	83 3b 00             	cmpl   $0x0,(%ebx)
    102d:	58                   	pop    %eax
    102e:	5a                   	pop    %edx
    102f:	eb e0                	jmp    1011 <regulatory_init+0xbc>
    1031:	85 f6                	test   %esi,%esi
    1033:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
    1038:	74 1e                	je     1058 <regulatory_init+0x103>
    103a:	8b 55 f0             	mov    -0x10(%ebp),%edx
    103d:	8a 02                	mov    (%edx),%al
    103f:	88 46 08             	mov    %al,0x8(%esi)
    1042:	8a 42 01             	mov    0x1(%edx),%al
    1045:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
    104c:	88 46 09             	mov    %al,0x9(%esi)
    104f:	89 f0                	mov    %esi,%eax
    1051:	e8 d5 fe ff ff       	call   f2b <queue_regulatory_request>
    1056:	31 c0                	xor    %eax,%eax
    1058:	8d 65 f4             	lea    -0xc(%ebp),%esp
    105b:	5b                   	pop    %ebx
    105c:	5e                   	pop    %esi
    105d:	5f                   	pop    %edi
    105e:	5d                   	pop    %ebp
    105f:	c3                   	ret    

00001060 <regulatory_hint_found_beacon>:
    1060:	55                   	push   %ebp
    1061:	89 e5                	mov    %esp,%ebp
    1063:	57                   	push   %edi
    1064:	56                   	push   %esi
    1065:	89 ce                	mov    %ecx,%esi
    1067:	53                   	push   %ebx
    1068:	83 ec 08             	sub    $0x8,%esp
    106b:	89 55 ec             	mov    %edx,-0x14(%ebp)
    106e:	80 7a 18 00          	cmpb   $0x0,0x18(%edx)
    1072:	0f 85 e4 00 00 00    	jne    115c <regulatory_hint_found_beacon+0xfc>
    1078:	f6 42 0c 08          	testb  $0x8,0xc(%edx)
    107c:	0f 85 da 00 00 00    	jne    115c <regulatory_hint_found_beacon+0xfc>
    1082:	83 3a 00             	cmpl   $0x0,(%edx)
    1085:	75 32                	jne    10b9 <regulatory_hint_found_beacon+0x59>
    1087:	b8 0c 00 00 00       	mov    $0xc,%eax
    108c:	0f b7 5a 04          	movzwl 0x4(%edx),%ebx
    1090:	e8 fc ff ff ff       	call   1091 <regulatory_hint_found_beacon+0x31>
    1095:	39 c3                	cmp    %eax,%ebx
    1097:	74 20                	je     10b9 <regulatory_hint_found_beacon+0x59>
    1099:	b8 0d 00 00 00       	mov    $0xd,%eax
    109e:	e8 fc ff ff ff       	call   109f <regulatory_hint_found_beacon+0x3f>
    10a3:	39 c3                	cmp    %eax,%ebx
    10a5:	74 12                	je     10b9 <regulatory_hint_found_beacon+0x59>
    10a7:	b8 0e 00 00 00       	mov    $0xe,%eax
    10ac:	e8 fc ff ff ff       	call   10ad <regulatory_hint_found_beacon+0x4d>
    10b1:	39 c3                	cmp    %eax,%ebx
    10b3:	0f 85 a3 00 00 00    	jne    115c <regulatory_hint_found_beacon+0xfc>
    10b9:	89 f7                	mov    %esi,%edi
    10bb:	81 cf 00 80 00 00    	or     $0x8000,%edi
    10c1:	f7 c7 01 00 00 00    	test   $0x1,%edi
    10c7:	75 45                	jne    110e <regulatory_hint_found_beacon+0xae>
    10c9:	89 fa                	mov    %edi,%edx
    10cb:	b8 78 03 00 00       	mov    $0x378,%eax
    10d0:	e8 fc ff ff ff       	call   10d1 <regulatory_hint_found_beacon+0x71>
    10d5:	83 3d 04 00 00 00 00 	cmpl   $0x0,0x4
    10dc:	89 c3                	mov    %eax,%ebx
    10de:	a1 7c 03 00 00       	mov    0x37c,%eax
    10e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    10e6:	74 34                	je     111c <regulatory_hint_found_beacon+0xbc>
    10e8:	8b 35 08 00 00 00    	mov    0x8,%esi
    10ee:	85 f6                	test   %esi,%esi
    10f0:	74 2a                	je     111c <regulatory_hint_found_beacon+0xbc>
    10f2:	57                   	push   %edi
    10f3:	89 da                	mov    %ebx,%edx
    10f5:	ff 75 f0             	pushl  -0x10(%ebp)
    10f8:	b8 c9 10 00 00       	mov    $0x10c9,%eax
    10fd:	b9 30 00 00 00       	mov    $0x30,%ecx
    1102:	ff 16                	call   *(%esi)
    1104:	83 c6 04             	add    $0x4,%esi
    1107:	83 3e 00             	cmpl   $0x0,(%esi)
    110a:	58                   	pop    %eax
    110b:	5a                   	pop    %edx
    110c:	eb e2                	jmp    10f0 <regulatory_hint_found_beacon+0x90>
    110e:	89 fa                	mov    %edi,%edx
    1110:	b8 30 00 00 00       	mov    $0x30,%eax
    1115:	e8 fc ff ff ff       	call   1116 <regulatory_hint_found_beacon+0xb6>
    111a:	89 c3                	mov    %eax,%ebx
    111c:	85 db                	test   %ebx,%ebx
    111e:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
    1123:	74 39                	je     115e <regulatory_hint_found_beacon+0xfe>
    1125:	8d 7b 08             	lea    0x8(%ebx),%edi
    1128:	b9 0a 00 00 00       	mov    $0xa,%ecx
    112d:	8b 75 ec             	mov    -0x14(%ebp),%esi
    1130:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    1132:	e8 fc ff ff ff       	call   1133 <regulatory_hint_found_beacon+0xd3>
    1137:	a1 18 00 00 00       	mov    0x18,%eax
    113c:	c7 03 14 00 00 00    	movl   $0x14,(%ebx)
    1142:	89 1d 18 00 00 00    	mov    %ebx,0x18
    1148:	89 18                	mov    %ebx,(%eax)
    114a:	89 43 04             	mov    %eax,0x4(%ebx)
    114d:	e8 fc ff ff ff       	call   114e <regulatory_hint_found_beacon+0xee>
    1152:	b8 04 00 00 00       	mov    $0x4,%eax
    1157:	e8 fc ff ff ff       	call   1158 <regulatory_hint_found_beacon+0xf8>
    115c:	31 c0                	xor    %eax,%eax
    115e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1161:	5b                   	pop    %ebx
    1162:	5e                   	pop    %esi
    1163:	5f                   	pop    %edi
    1164:	5d                   	pop    %ebp
    1165:	c3                   	ret    

00001166 <regulatory_exit>:
    1166:	55                   	push   %ebp
    1167:	b8 04 00 00 00       	mov    $0x4,%eax
    116c:	89 e5                	mov    %esp,%ebp
    116e:	53                   	push   %ebx
    116f:	e8 fc ff ff ff       	call   1170 <regulatory_exit+0xa>
    1174:	b8 00 00 00 00       	mov    $0x0,%eax
    1179:	e8 fc ff ff ff       	call   117a <regulatory_exit+0x14>
    117e:	e8 25 f1 ff ff       	call   2a8 <reset_regdomains>
    1183:	a1 0c 00 00 00       	mov    0xc,%eax
    1188:	e8 fc ff ff ff       	call   1189 <regulatory_exit+0x23>
    118d:	a1 04 00 00 00       	mov    0x4,%eax
    1192:	c7 05 0c 00 00 00 00 	movl   $0x0,0xc
    1199:	00 00 00 
    119c:	e8 fc ff ff ff       	call   119d <regulatory_exit+0x37>
    11a1:	a1 08 00 00 00       	mov    0x8,%eax
    11a6:	e8 fc ff ff ff       	call   11a7 <regulatory_exit+0x41>
    11ab:	e8 fc ff ff ff       	call   11ac <regulatory_exit+0x46>
    11b0:	a1 14 00 00 00       	mov    0x14,%eax
    11b5:	3d 14 00 00 00       	cmp    $0x14,%eax
    11ba:	74 30                	je     11ec <regulatory_exit+0x86>
    11bc:	8b 18                	mov    (%eax),%ebx
    11be:	89 c1                	mov    %eax,%ecx
    11c0:	eb 22                	jmp    11e4 <regulatory_exit+0x7e>
    11c2:	8b 41 04             	mov    0x4(%ecx),%eax
    11c5:	8b 11                	mov    (%ecx),%edx
    11c7:	89 42 04             	mov    %eax,0x4(%edx)
    11ca:	89 10                	mov    %edx,(%eax)
    11cc:	89 c8                	mov    %ecx,%eax
    11ce:	c7 01 00 01 10 00    	movl   $0x100100,(%ecx)
    11d4:	c7 41 04 00 02 20 00 	movl   $0x200200,0x4(%ecx)
    11db:	e8 fc ff ff ff       	call   11dc <regulatory_exit+0x76>
    11e0:	89 d9                	mov    %ebx,%ecx
    11e2:	8b 1b                	mov    (%ebx),%ebx
    11e4:	81 f9 14 00 00 00    	cmp    $0x14,%ecx
    11ea:	75 d6                	jne    11c2 <regulatory_exit+0x5c>
    11ec:	e8 fc ff ff ff       	call   11ed <regulatory_exit+0x87>
    11f1:	a1 1c 00 00 00       	mov    0x1c,%eax
    11f6:	3d 1c 00 00 00       	cmp    $0x1c,%eax
    11fb:	74 30                	je     122d <regulatory_exit+0xc7>
    11fd:	8b 18                	mov    (%eax),%ebx
    11ff:	89 c1                	mov    %eax,%ecx
    1201:	eb 22                	jmp    1225 <regulatory_exit+0xbf>
    1203:	8b 41 04             	mov    0x4(%ecx),%eax
    1206:	8b 11                	mov    (%ecx),%edx
    1208:	89 42 04             	mov    %eax,0x4(%edx)
    120b:	89 10                	mov    %edx,(%eax)
    120d:	89 c8                	mov    %ecx,%eax
    120f:	c7 01 00 01 10 00    	movl   $0x100100,(%ecx)
    1215:	c7 41 04 00 02 20 00 	movl   $0x200200,0x4(%ecx)
    121c:	e8 fc ff ff ff       	call   121d <regulatory_exit+0xb7>
    1221:	89 d9                	mov    %ebx,%ecx
    1223:	8b 1b                	mov    (%ebx),%ebx
    1225:	81 f9 1c 00 00 00    	cmp    $0x1c,%ecx
    122b:	75 d6                	jne    1203 <regulatory_exit+0x9d>
    122d:	a1 24 00 00 00       	mov    0x24,%eax
    1232:	3d 24 00 00 00       	cmp    $0x24,%eax
    1237:	74 38                	je     1271 <regulatory_exit+0x10b>
    1239:	8d 48 ec             	lea    -0x14(%eax),%ecx
    123c:	8b 59 14             	mov    0x14(%ecx),%ebx
    123f:	eb 25                	jmp    1266 <regulatory_exit+0x100>
    1241:	8b 41 18             	mov    0x18(%ecx),%eax
    1244:	8b 51 14             	mov    0x14(%ecx),%edx
    1247:	89 42 04             	mov    %eax,0x4(%edx)
    124a:	89 10                	mov    %edx,(%eax)
    124c:	89 c8                	mov    %ecx,%eax
    124e:	c7 41 14 00 01 10 00 	movl   $0x100100,0x14(%ecx)
    1255:	c7 41 18 00 02 20 00 	movl   $0x200200,0x18(%ecx)
    125c:	e8 fc ff ff ff       	call   125d <regulatory_exit+0xf7>
    1261:	89 d9                	mov    %ebx,%ecx
    1263:	8b 5b 14             	mov    0x14(%ebx),%ebx
    1266:	83 eb 14             	sub    $0x14,%ebx
    1269:	81 f9 10 00 00 00    	cmp    $0x10,%ecx
    126f:	75 d0                	jne    1241 <regulatory_exit+0xdb>
    1271:	b8 00 00 00 00       	mov    $0x0,%eax
    1276:	e8 fc ff ff ff       	call   1277 <regulatory_exit+0x111>
    127b:	5b                   	pop    %ebx
    127c:	5d                   	pop    %ebp
    127d:	c3                   	ret    

0000127e <set_regdom>:
    127e:	55                   	push   %ebp
    127f:	89 e5                	mov    %esp,%ebp
    1281:	57                   	push   %edi
    1282:	56                   	push   %esi
    1283:	89 c6                	mov    %eax,%esi
    1285:	a1 00 00 00 00       	mov    0x0,%eax
    128a:	53                   	push   %ebx
    128b:	48                   	dec    %eax
    128c:	75 11                	jne    129f <set_regdom+0x21>
    128e:	6a 00                	push   $0x0
    1290:	6a 4e                	push   $0x4e
    1292:	68 13 00 00 00       	push   $0x13
    1297:	e8 fc ff ff ff       	call   1298 <set_regdom+0x1a>
    129c:	83 c4 0c             	add    $0xc,%esp
    129f:	8d 5e 04             	lea    0x4(%esi),%ebx
    12a2:	89 d8                	mov    %ebx,%eax
    12a4:	e8 fc ff ff ff       	call   12a5 <set_regdom+0x27>
    12a9:	84 c0                	test   %al,%al
    12ab:	74 34                	je     12e1 <set_regdom+0x63>
    12ad:	89 d8                	mov    %ebx,%eax
    12af:	e8 fc ff ff ff       	call   12b0 <set_regdom+0x32>
    12b4:	84 c0                	test   %al,%al
    12b6:	75 0c                	jne    12c4 <set_regdom+0x46>
    12b8:	6a 00                	push   $0x0
    12ba:	68 ff 07 00 00       	push   $0x7ff
    12bf:	e9 89 00 00 00       	jmp    134d <set_regdom+0xcf>
    12c4:	83 3d 04 00 00 00 00 	cmpl   $0x0,0x4
    12cb:	75 04                	jne    12d1 <set_regdom+0x53>
    12cd:	0f 0b                	ud2a   
    12cf:	eb fe                	jmp    12cf <set_regdom+0x51>
    12d1:	e8 d2 ef ff ff       	call   2a8 <reset_regdomains>
    12d6:	89 35 2c 00 00 00    	mov    %esi,0x2c
    12dc:	e9 16 01 00 00       	jmp    13f7 <set_regdom+0x179>
    12e1:	85 db                	test   %ebx,%ebx
    12e3:	74 0c                	je     12f1 <set_regdom+0x73>
    12e5:	80 7e 04 00          	cmpb   $0x0,0x4(%esi)
    12e9:	74 06                	je     12f1 <set_regdom+0x73>
    12eb:	80 7e 05 00          	cmpb   $0x0,0x5(%esi)
    12ef:	75 1a                	jne    130b <set_regdom+0x8d>
    12f1:	89 d8                	mov    %ebx,%eax
    12f3:	e8 65 ed ff ff       	call   5d <is_an_alpha2>
    12f8:	84 c0                	test   %al,%al
    12fa:	75 0f                	jne    130b <set_regdom+0x8d>
    12fc:	89 d8                	mov    %ebx,%eax
    12fe:	e8 3e ed ff ff       	call   41 <is_unknown_alpha2>
    1303:	84 c0                	test   %al,%al
    1305:	0f 84 9c 01 00 00    	je     14a7 <set_regdom+0x229>
    130b:	a1 04 00 00 00       	mov    0x4,%eax
    1310:	85 c0                	test   %eax,%eax
    1312:	0f 84 8f 01 00 00    	je     14a7 <set_regdom+0x229>
    1318:	83 78 04 03          	cmpl   $0x3,0x4(%eax)
    131c:	74 1d                	je     133b <set_regdom+0xbd>
    131e:	a1 00 00 00 00       	mov    0x0,%eax
    1323:	e8 d8 ec ff ff       	call   0 <is_old_static_regdom>
    1328:	84 c0                	test   %al,%al
    132a:	75 0f                	jne    133b <set_regdom+0xbd>
    132c:	89 d8                	mov    %ebx,%eax
    132e:	e8 08 f1 ff ff       	call   43b <regdom_changes>
    1333:	84 c0                	test   %al,%al
    1335:	0f 84 6c 01 00 00    	je     14a7 <set_regdom+0x229>
    133b:	89 d8                	mov    %ebx,%eax
    133d:	e8 fc ff ff ff       	call   133e <set_regdom+0xc0>
    1342:	84 c0                	test   %al,%al
    1344:	75 19                	jne    135f <set_regdom+0xe1>
    1346:	6a 00                	push   $0x0
    1348:	68 22 08 00 00       	push   $0x822
    134d:	68 00 00 00 00       	push   $0x0
    1352:	e8 fc ff ff ff       	call   1353 <set_regdom+0xd5>
    1357:	83 c4 0c             	add    $0xc,%esp
    135a:	e9 48 01 00 00       	jmp    14a7 <set_regdom+0x229>
    135f:	8b 1e                	mov    (%esi),%ebx
    1361:	85 db                	test   %ebx,%ebx
    1363:	74 34                	je     1399 <set_regdom+0x11b>
    1365:	31 ff                	xor    %edi,%edi
    1367:	83 fb 20             	cmp    $0x20,%ebx
    136a:	76 16                	jbe    1382 <set_regdom+0x104>
    136c:	6a 00                	push   $0x0
    136e:	68 a5 01 00 00       	push   $0x1a5
    1373:	68 00 00 00 00       	push   $0x0
    1378:	e8 fc ff ff ff       	call   1379 <set_regdom+0xfb>
    137d:	83 c4 0c             	add    $0xc,%esp
    1380:	eb 17                	jmp    1399 <set_regdom+0x11b>
    1382:	6b c7 18             	imul   $0x18,%edi,%eax
    1385:	8d 44 06 08          	lea    0x8(%esi,%eax,1),%eax
    1389:	e8 37 ed ff ff       	call   c5 <is_valid_reg_rule>
    138e:	84 c0                	test   %al,%al
    1390:	74 07                	je     1399 <set_regdom+0x11b>
    1392:	47                   	inc    %edi
    1393:	39 df                	cmp    %ebx,%edi
    1395:	74 1e                	je     13b5 <set_regdom+0x137>
    1397:	eb e9                	jmp    1382 <set_regdom+0x104>
    1399:	68 9c 01 00 00       	push   $0x19c
    139e:	bb ea ff ff ff       	mov    $0xffffffea,%ebx
    13a3:	e8 fc ff ff ff       	call   13a4 <set_regdom+0x126>
    13a8:	89 f0                	mov    %esi,%eax
    13aa:	e8 26 f3 ff ff       	call   6d5 <print_regdomain_info>
    13af:	5f                   	pop    %edi
    13b0:	e9 f7 00 00 00       	jmp    14ac <set_regdom+0x22e>
    13b5:	a1 04 00 00 00       	mov    0x4,%eax
    13ba:	8b 00                	mov    (%eax),%eax
    13bc:	e8 fc ff ff ff       	call   13bd <set_regdom+0x13f>
    13c1:	89 c7                	mov    %eax,%edi
    13c3:	a1 04 00 00 00       	mov    0x4,%eax
    13c8:	80 78 0a 00          	cmpb   $0x0,0xa(%eax)
    13cc:	75 34                	jne    1402 <set_regdom+0x184>
    13ce:	83 78 04 02          	cmpl   $0x2,0x4(%eax)
    13d2:	75 1e                	jne    13f2 <set_regdom+0x174>
    13d4:	83 7f 30 00          	cmpl   $0x0,0x30(%edi)
    13d8:	74 04                	je     13de <set_regdom+0x160>
    13da:	0f 0b                	ud2a   
    13dc:	eb fe                	jmp    13dc <set_regdom+0x15e>
    13de:	8d 47 30             	lea    0x30(%edi),%eax
    13e1:	89 f2                	mov    %esi,%edx
    13e3:	e8 f7 f0 ff ff       	call   4df <reg_copy_regd>
    13e8:	85 c0                	test   %eax,%eax
    13ea:	89 c3                	mov    %eax,%ebx
    13ec:	0f 85 ba 00 00 00    	jne    14ac <set_regdom+0x22e>
    13f2:	e8 b1 ee ff ff       	call   2a8 <reset_regdomains>
    13f7:	89 35 00 00 00 00    	mov    %esi,0x0
    13fd:	e9 86 01 00 00       	jmp    1588 <set_regdom+0x30a>
    1402:	83 78 04 03          	cmpl   $0x3,0x4(%eax)
    1406:	74 27                	je     142f <set_regdom+0x1b1>
    1408:	8b 15 00 00 00 00    	mov    0x0,%edx
    140e:	89 f0                	mov    %esi,%eax
    1410:	e8 34 f1 ff ff       	call   549 <regdom_intersect>
    1415:	85 c0                	test   %eax,%eax
    1417:	89 c3                	mov    %eax,%ebx
    1419:	0f 84 88 00 00 00    	je     14a7 <set_regdom+0x229>
    141f:	a1 04 00 00 00       	mov    0x4,%eax
    1424:	83 78 04 02          	cmpl   $0x2,0x4(%eax)
    1428:	75 66                	jne    1490 <set_regdom+0x212>
    142a:	89 77 30             	mov    %esi,0x30(%edi)
    142d:	eb 68                	jmp    1497 <set_regdom+0x219>
    142f:	8b 15 0c 00 00 00    	mov    0xc,%edx
    1435:	85 d2                	test   %edx,%edx
    1437:	75 04                	jne    143d <set_regdom+0x1bf>
    1439:	0f 0b                	ud2a   
    143b:	eb fe                	jmp    143b <set_regdom+0x1bd>
    143d:	39 d6                	cmp    %edx,%esi
    143f:	75 04                	jne    1445 <set_regdom+0x1c7>
    1441:	0f 0b                	ud2a   
    1443:	eb fe                	jmp    1443 <set_regdom+0x1c5>
    1445:	89 f0                	mov    %esi,%eax
    1447:	e8 fd f0 ff ff       	call   549 <regdom_intersect>
    144c:	89 c3                	mov    %eax,%ebx
    144e:	a1 0c 00 00 00       	mov    0xc,%eax
    1453:	e8 fc ff ff ff       	call   1454 <set_regdom+0x1d6>
    1458:	85 db                	test   %ebx,%ebx
    145a:	c7 05 0c 00 00 00 00 	movl   $0x0,0xc
    1461:	00 00 00 
    1464:	74 41                	je     14a7 <set_regdom+0x229>
    1466:	85 ff                	test   %edi,%edi
    1468:	75 04                	jne    146e <set_regdom+0x1f0>
    146a:	0f 0b                	ud2a   
    146c:	eb fe                	jmp    146c <set_regdom+0x1ee>
    146e:	8a 46 04             	mov    0x4(%esi),%al
    1471:	8d 57 a0             	lea    -0x60(%edi),%edx
    1474:	39 f3                	cmp    %esi,%ebx
    1476:	88 42 18             	mov    %al,0x18(%edx)
    1479:	8a 46 05             	mov    0x5(%esi),%al
    147c:	88 42 19             	mov    %al,0x19(%edx)
    147f:	a1 04 00 00 00       	mov    0x4,%eax
    1484:	8b 40 10             	mov    0x10(%eax),%eax
    1487:	89 42 1c             	mov    %eax,0x1c(%edx)
    148a:	75 04                	jne    1490 <set_regdom+0x212>
    148c:	0f 0b                	ud2a   
    148e:	eb fe                	jmp    148e <set_regdom+0x210>
    1490:	89 f0                	mov    %esi,%eax
    1492:	e8 fc ff ff ff       	call   1493 <set_regdom+0x215>
    1497:	e8 0c ee ff ff       	call   2a8 <reset_regdomains>
    149c:	89 1d 00 00 00 00    	mov    %ebx,0x0
    14a2:	e9 e1 00 00 00       	jmp    1588 <set_regdom+0x30a>
    14a7:	bb ea ff ff ff       	mov    $0xffffffea,%ebx
    14ac:	89 f0                	mov    %esi,%eax
    14ae:	e8 fc ff ff ff       	call   14af <set_regdom+0x231>
    14b3:	e9 f4 00 00 00       	jmp    15ac <set_regdom+0x32e>
    14b8:	3b 35 00 00 00 00    	cmp    0x0,%esi
    14be:	74 04                	je     14c4 <set_regdom+0x246>
    14c0:	0f 0b                	ud2a   
    14c2:	eb fe                	jmp    14c2 <set_regdom+0x244>
    14c4:	8b 70 04             	mov    0x4(%eax),%esi
    14c7:	8b 1d 00 00 00 00    	mov    0x0,%ebx
    14cd:	eb 0d                	jmp    14dc <set_regdom+0x25e>
    14cf:	8d 43 60             	lea    0x60(%ebx),%eax
    14d2:	89 f2                	mov    %esi,%edx
    14d4:	e8 fc ff ff ff       	call   14d5 <set_regdom+0x257>
    14d9:	8b 5b 04             	mov    0x4(%ebx),%ebx
    14dc:	83 eb 04             	sub    $0x4,%ebx
    14df:	8b 43 04             	mov    0x4(%ebx),%eax
    14e2:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    14e6:	81 fb fc ff ff ff    	cmp    $0xfffffffc,%ebx
    14ec:	75 e1                	jne    14cf <set_regdom+0x251>
    14ee:	8b 1d 00 00 00 00    	mov    0x0,%ebx
    14f4:	89 de                	mov    %ebx,%esi
    14f6:	83 c6 04             	add    $0x4,%esi
    14f9:	74 10                	je     150b <set_regdom+0x28d>
    14fb:	80 7b 04 39          	cmpb   $0x39,0x4(%ebx)
    14ff:	75 0a                	jne    150b <set_regdom+0x28d>
    1501:	80 7b 05 38          	cmpb   $0x38,0x5(%ebx)
    1505:	0f 84 91 00 00 00    	je     159c <set_regdom+0x31e>
    150b:	89 f0                	mov    %esi,%eax
    150d:	e8 fc ff ff ff       	call   150e <set_regdom+0x290>
    1512:	84 c0                	test   %al,%al
    1514:	75 27                	jne    153d <set_regdom+0x2bf>
    1516:	eb 2c                	jmp    1544 <set_regdom+0x2c6>
    1518:	8b 00                	mov    (%eax),%eax
    151a:	e8 fc ff ff ff       	call   151b <set_regdom+0x29d>
    151f:	85 c0                	test   %eax,%eax
    1521:	89 c2                	mov    %eax,%edx
    1523:	74 11                	je     1536 <set_regdom+0x2b8>
    1525:	0f be 40 19          	movsbl 0x19(%eax),%eax
    1529:	50                   	push   %eax
    152a:	0f be 42 18          	movsbl 0x18(%edx),%eax
    152e:	50                   	push   %eax
    152f:	68 ce 01 00 00       	push   $0x1ce
    1534:	eb 35                	jmp    156b <set_regdom+0x2ed>
    1536:	68 0d 02 00 00       	push   $0x20d
    153b:	eb 17                	jmp    1554 <set_regdom+0x2d6>
    153d:	68 43 02 00 00       	push   $0x243
    1542:	eb 10                	jmp    1554 <set_regdom+0x2d6>
    1544:	89 f0                	mov    %esi,%eax
    1546:	e8 f6 ea ff ff       	call   41 <is_unknown_alpha2>
    154b:	84 c0                	test   %al,%al
    154d:	74 0d                	je     155c <set_regdom+0x2de>
    154f:	68 72 02 00 00       	push   $0x272
    1554:	e8 fc ff ff ff       	call   1555 <set_regdom+0x2d7>
    1559:	59                   	pop    %ecx
    155a:	eb 17                	jmp    1573 <set_regdom+0x2f5>
    155c:	0f be 43 05          	movsbl 0x5(%ebx),%eax
    1560:	50                   	push   %eax
    1561:	0f be 43 04          	movsbl 0x4(%ebx),%eax
    1565:	50                   	push   %eax
    1566:	68 c8 02 00 00       	push   $0x2c8
    156b:	e8 fc ff ff ff       	call   156c <set_regdom+0x2ee>
    1570:	83 c4 0c             	add    $0xc,%esp
    1573:	89 d8                	mov    %ebx,%eax
    1575:	31 db                	xor    %ebx,%ebx
    1577:	e8 f5 f0 ff ff       	call   671 <print_rd_rules>
    157c:	a1 04 00 00 00       	mov    0x4,%eax
    1581:	e8 fc ff ff ff       	call   1582 <set_regdom+0x304>
    1586:	eb 24                	jmp    15ac <set_regdom+0x32e>
    1588:	a1 04 00 00 00       	mov    0x4,%eax
    158d:	80 78 0a 00          	cmpb   $0x0,0xa(%eax)
    1591:	0f 85 2d ff ff ff    	jne    14c4 <set_regdom+0x246>
    1597:	e9 1c ff ff ff       	jmp    14b8 <set_regdom+0x23a>
    159c:	a1 04 00 00 00       	mov    0x4,%eax
    15a1:	83 78 04 03          	cmpl   $0x3,0x4(%eax)
    15a5:	75 8f                	jne    1536 <set_regdom+0x2b8>
    15a7:	e9 6c ff ff ff       	jmp    1518 <set_regdom+0x29a>
    15ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
    15af:	89 d8                	mov    %ebx,%eax
    15b1:	5b                   	pop    %ebx
    15b2:	5e                   	pop    %esi
    15b3:	5f                   	pop    %edi
    15b4:	5d                   	pop    %ebp
    15b5:	c3                   	ret    

000015b6 <regulatory_hint_user>:
    15b6:	55                   	push   %ebp
    15b7:	89 e5                	mov    %esp,%ebp
    15b9:	57                   	push   %edi
    15ba:	89 c7                	mov    %eax,%edi
    15bc:	56                   	push   %esi
    15bd:	53                   	push   %ebx
    15be:	83 ec 04             	sub    $0x4,%esp
    15c1:	85 c0                	test   %eax,%eax
    15c3:	75 04                	jne    15c9 <regulatory_hint_user+0x13>
    15c5:	0f 0b                	ud2a   
    15c7:	eb fe                	jmp    15c7 <regulatory_hint_user+0x11>
    15c9:	ba d0 80 00 00       	mov    $0x80d0,%edx
    15ce:	b8 e4 02 00 00       	mov    $0x2e4,%eax
    15d3:	e8 fc ff ff ff       	call   15d4 <regulatory_hint_user+0x1e>
    15d8:	83 3d 04 00 00 00 00 	cmpl   $0x0,0x4
    15df:	89 c3                	mov    %eax,%ebx
    15e1:	a1 e8 02 00 00       	mov    0x2e8,%eax
    15e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    15e9:	74 2a                	je     1615 <regulatory_hint_user+0x5f>
    15eb:	8b 35 08 00 00 00    	mov    0x8,%esi
    15f1:	85 f6                	test   %esi,%esi
    15f3:	74 20                	je     1615 <regulatory_hint_user+0x5f>
    15f5:	68 d0 80 00 00       	push   $0x80d0
    15fa:	89 da                	mov    %ebx,%edx
    15fc:	ff 75 f0             	pushl  -0x10(%ebp)
    15ff:	b8 c9 15 00 00       	mov    $0x15c9,%eax
    1604:	b9 1c 00 00 00       	mov    $0x1c,%ecx
    1609:	ff 16                	call   *(%esi)
    160b:	83 c6 04             	add    $0x4,%esi
    160e:	83 3e 00             	cmpl   $0x0,(%esi)
    1611:	58                   	pop    %eax
    1612:	5a                   	pop    %edx
    1613:	eb de                	jmp    15f3 <regulatory_hint_user+0x3d>
    1615:	85 db                	test   %ebx,%ebx
    1617:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
    161c:	74 21                	je     163f <regulatory_hint_user+0x89>
    161e:	c7 03 ff ff ff ff    	movl   $0xffffffff,(%ebx)
    1624:	8a 07                	mov    (%edi),%al
    1626:	88 43 08             	mov    %al,0x8(%ebx)
    1629:	8a 47 01             	mov    0x1(%edi),%al
    162c:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
    1633:	88 43 09             	mov    %al,0x9(%ebx)
    1636:	89 d8                	mov    %ebx,%eax
    1638:	e8 ee f8 ff ff       	call   f2b <queue_regulatory_request>
    163d:	31 c0                	xor    %eax,%eax
    163f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1642:	5b                   	pop    %ebx
    1643:	5e                   	pop    %esi
    1644:	5f                   	pop    %edi
    1645:	5d                   	pop    %ebp
    1646:	c3                   	ret    

00001647 <regulatory_hint>:
    1647:	55                   	push   %ebp
    1648:	89 e5                	mov    %esp,%ebp
    164a:	57                   	push   %edi
    164b:	89 d7                	mov    %edx,%edi
    164d:	56                   	push   %esi
    164e:	53                   	push   %ebx
    164f:	83 ec 08             	sub    $0x8,%esp
    1652:	85 d2                	test   %edx,%edx
    1654:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1657:	75 04                	jne    165d <regulatory_hint+0x16>
    1659:	0f 0b                	ud2a   
    165b:	eb fe                	jmp    165b <regulatory_hint+0x14>
    165d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1661:	75 04                	jne    1667 <regulatory_hint+0x20>
    1663:	0f 0b                	ud2a   
    1665:	eb fe                	jmp    1665 <regulatory_hint+0x1e>
    1667:	ba d0 80 00 00       	mov    $0x80d0,%edx
    166c:	b8 e4 02 00 00       	mov    $0x2e4,%eax
    1671:	e8 fc ff ff ff       	call   1672 <regulatory_hint+0x2b>
    1676:	83 3d 04 00 00 00 00 	cmpl   $0x0,0x4
    167d:	89 c6                	mov    %eax,%esi
    167f:	a1 e8 02 00 00       	mov    0x2e8,%eax
    1684:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1687:	74 2a                	je     16b3 <regulatory_hint+0x6c>
    1689:	8b 1d 08 00 00 00    	mov    0x8,%ebx
    168f:	85 db                	test   %ebx,%ebx
    1691:	74 20                	je     16b3 <regulatory_hint+0x6c>
    1693:	68 d0 80 00 00       	push   $0x80d0
    1698:	b9 1c 00 00 00       	mov    $0x1c,%ecx
    169d:	ff 75 f0             	pushl  -0x10(%ebp)
    16a0:	b8 67 16 00 00       	mov    $0x1667,%eax
    16a5:	89 f2                	mov    %esi,%edx
    16a7:	ff 13                	call   *(%ebx)
    16a9:	83 c3 04             	add    $0x4,%ebx
    16ac:	83 3b 00             	cmpl   $0x0,(%ebx)
    16af:	59                   	pop    %ecx
    16b0:	58                   	pop    %eax
    16b1:	eb de                	jmp    1691 <regulatory_hint+0x4a>
    16b3:	85 f6                	test   %esi,%esi
    16b5:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
    16ba:	74 2d                	je     16e9 <regulatory_hint+0xa2>
    16bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
    16bf:	e8 fc ff ff ff       	call   16c0 <regulatory_hint+0x79>
    16c4:	85 c0                	test   %eax,%eax
    16c6:	89 06                	mov    %eax,(%esi)
    16c8:	79 04                	jns    16ce <regulatory_hint+0x87>
    16ca:	0f 0b                	ud2a   
    16cc:	eb fe                	jmp    16cc <regulatory_hint+0x85>
    16ce:	8a 07                	mov    (%edi),%al
    16d0:	88 46 08             	mov    %al,0x8(%esi)
    16d3:	8a 47 01             	mov    0x1(%edi),%al
    16d6:	c7 46 04 02 00 00 00 	movl   $0x2,0x4(%esi)
    16dd:	88 46 09             	mov    %al,0x9(%esi)
    16e0:	89 f0                	mov    %esi,%eax
    16e2:	e8 44 f8 ff ff       	call   f2b <queue_regulatory_request>
    16e7:	31 c0                	xor    %eax,%eax
    16e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
    16ec:	5b                   	pop    %ebx
    16ed:	5e                   	pop    %esi
    16ee:	5f                   	pop    %edi
    16ef:	5d                   	pop    %ebp
    16f0:	c3                   	ret    

000016f1 <regulatory_hint_11d>:
    16f1:	55                   	push   %ebp
    16f2:	89 e5                	mov    %esp,%ebp
    16f4:	57                   	push   %edi
    16f5:	56                   	push   %esi
    16f6:	53                   	push   %ebx
    16f7:	89 d3                	mov    %edx,%ebx
    16f9:	83 ec 3c             	sub    $0x3c,%esp
    16fc:	89 45 bc             	mov    %eax,-0x44(%ebp)
    16ff:	b8 00 00 00 00       	mov    $0x0,%eax
    1704:	88 4d bb             	mov    %cl,-0x45(%ebp)
    1707:	e8 fc ff ff ff       	call   1708 <regulatory_hint_11d+0x17>
    170c:	8b 15 04 00 00 00    	mov    0x4,%edx
    1712:	85 d2                	test   %edx,%edx
    1714:	0f 84 57 03 00 00    	je     1a71 <regulatory_hint_11d+0x380>
    171a:	0f b6 45 bb          	movzbl -0x45(%ebp),%eax
    171e:	a8 01                	test   $0x1,%al
    1720:	0f 85 4b 03 00 00    	jne    1a71 <regulatory_hint_11d+0x380>
    1726:	80 7d bb 05          	cmpb   $0x5,-0x45(%ebp)
    172a:	0f 86 41 03 00 00    	jbe    1a71 <regulatory_hint_11d+0x380>
    1730:	83 3d 0c 00 00 00 00 	cmpl   $0x0,0xc
    1737:	0f 85 34 03 00 00    	jne    1a71 <regulatory_hint_11d+0x380>
    173d:	8a 03                	mov    (%ebx),%al
    173f:	8d 73 01             	lea    0x1(%ebx),%esi
    1742:	8d 4b 02             	lea    0x2(%ebx),%ecx
    1745:	88 45 f2             	mov    %al,-0xe(%ebp)
    1748:	8a 43 01             	mov    0x1(%ebx),%al
    174b:	88 45 f3             	mov    %al,-0xd(%ebp)
    174e:	8a 43 02             	mov    0x2(%ebx),%al
    1751:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    1758:	3c 49                	cmp    $0x49,%al
    175a:	74 0d                	je     1769 <regulatory_hint_11d+0x78>
    175c:	3c 4f                	cmp    $0x4f,%al
    175e:	0f 94 c0             	sete   %al
    1761:	0f b6 c0             	movzbl %al,%eax
    1764:	01 c0                	add    %eax,%eax
    1766:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    1769:	83 7a 04 03          	cmpl   $0x3,0x4(%edx)
    176d:	75 2d                	jne    179c <regulatory_hint_11d+0xab>
    176f:	8b 02                	mov    (%edx),%eax
    1771:	85 c0                	test   %eax,%eax
    1773:	78 27                	js     179c <regulatory_hint_11d+0xab>
    1775:	e8 fc ff ff ff       	call   1776 <regulatory_hint_11d+0x85>
    177a:	8d 50 60             	lea    0x60(%eax),%edx
    177d:	3b 55 bc             	cmp    -0x44(%ebp),%edx
    1780:	8d 40 18             	lea    0x18(%eax),%eax
    1783:	8d 55 f2             	lea    -0xe(%ebp),%edx
    1786:	75 0a                	jne    1792 <regulatory_hint_11d+0xa1>
    1788:	e8 f4 e8 ff ff       	call   81 <alpha2_equal>
    178d:	e9 df 02 00 00       	jmp    1a71 <regulatory_hint_11d+0x380>
    1792:	e8 ea e8 ff ff       	call   81 <alpha2_equal>
    1797:	e9 d5 02 00 00       	jmp    1a71 <regulatory_hint_11d+0x380>
    179c:	8a 03                	mov    (%ebx),%al
    179e:	88 45 df             	mov    %al,-0x21(%ebp)
    17a1:	8a 16                	mov    (%esi),%dl
    17a3:	88 55 de             	mov    %dl,-0x22(%ebp)
    17a6:	8a 01                	mov    (%ecx),%al
    17a8:	c7 45 d4 08 00 00 00 	movl   $0x8,-0x2c(%ebp)
    17af:	3c 49                	cmp    $0x49,%al
    17b1:	74 0e                	je     17c1 <regulatory_hint_11d+0xd0>
    17b3:	3c 4f                	cmp    $0x4f,%al
    17b5:	0f 94 c0             	sete   %al
    17b8:	0f b6 c0             	movzbl %al,%eax
    17bb:	c1 e0 02             	shl    $0x2,%eax
    17be:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    17c1:	8a 45 df             	mov    -0x21(%ebp),%al
    17c4:	83 c3 06             	add    $0x6,%ebx
    17c7:	31 ff                	xor    %edi,%edi
    17c9:	32 45 de             	xor    -0x22(%ebp),%al
    17cc:	89 de                	mov    %ebx,%esi
    17ce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
    17d1:	89 5d e8             	mov    %ebx,-0x18(%ebp)
    17d4:	0f be c0             	movsbl %al,%eax
    17d7:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    17de:	31 d0                	xor    %edx,%eax
    17e0:	c1 e0 08             	shl    $0x8,%eax
    17e3:	35 ef be ad de       	xor    $0xdeadbeef,%eax
    17e8:	89 45 c0             	mov    %eax,-0x40(%ebp)
    17eb:	8a 45 bb             	mov    -0x45(%ebp),%al
    17ee:	2c 06                	sub    $0x6,%al
    17f0:	88 45 ef             	mov    %al,-0x11(%ebp)
    17f3:	88 45 e7             	mov    %al,-0x19(%ebp)
    17f6:	eb 6f                	jmp    1867 <regulatory_hint_11d+0x176>
    17f8:	8a 46 fd             	mov    -0x3(%esi),%al
    17fb:	8d 5e fd             	lea    -0x3(%esi),%ebx
    17fe:	3c c8                	cmp    $0xc8,%al
    1800:	77 5e                	ja     1860 <regulatory_hint_11d+0x16f>
    1802:	3c 0e                	cmp    $0xe,%al
    1804:	8a 4b 01             	mov    0x1(%ebx),%cl
    1807:	77 0a                	ja     1813 <regulatory_hint_11d+0x122>
    1809:	0f b6 d1             	movzbl %cl,%edx
    180c:	0f b6 c0             	movzbl %al,%eax
    180f:	01 c2                	add    %eax,%edx
    1811:	eb 0a                	jmp    181d <regulatory_hint_11d+0x12c>
    1813:	0f b6 d0             	movzbl %al,%edx
    1816:	0f b6 c1             	movzbl %cl,%eax
    1819:	8d 54 82 fc          	lea    -0x4(%edx,%eax,4),%edx
    181d:	0f b6 0b             	movzbl (%ebx),%ecx
    1820:	39 ca                	cmp    %ecx,%edx
    1822:	0f 8c 49 02 00 00    	jl     1a71 <regulatory_hint_11d+0x380>
    1828:	85 ff                	test   %edi,%edi
    182a:	74 10                	je     183c <regulatory_hint_11d+0x14b>
    182c:	39 f9                	cmp    %edi,%ecx
    182e:	0f 8e 3d 02 00 00    	jle    1a71 <regulatory_hint_11d+0x380>
    1834:	39 fa                	cmp    %edi,%edx
    1836:	0f 8e 35 02 00 00    	jle    1a71 <regulatory_hint_11d+0x380>
    183c:	8a 43 02             	mov    0x2(%ebx),%al
    183f:	ff 45 d0             	incl   -0x30(%ebp)
    1842:	83 7d d0 20          	cmpl   $0x20,-0x30(%ebp)
    1846:	0f 87 25 02 00 00    	ja     1a71 <regulatory_hint_11d+0x380>
    184c:	0f be c0             	movsbl %al,%eax
    184f:	31 d1                	xor    %edx,%ecx
    1851:	31 d0                	xor    %edx,%eax
    1853:	89 d7                	mov    %edx,%edi
    1855:	c1 e0 18             	shl    $0x18,%eax
    1858:	c1 e1 08             	shl    $0x8,%ecx
    185b:	09 c8                	or     %ecx,%eax
    185d:	31 45 c0             	xor    %eax,-0x40(%ebp)
    1860:	80 6d e7 03          	subb   $0x3,-0x19(%ebp)
    1864:	83 c6 03             	add    $0x3,%esi
    1867:	8a 45 e7             	mov    -0x19(%ebp),%al
    186a:	04 03                	add    $0x3,%al
    186c:	3c 02                	cmp    $0x2,%al
    186e:	77 88                	ja     17f8 <regulatory_hint_11d+0x107>
    1870:	6b 45 d0 18          	imul   $0x18,-0x30(%ebp),%eax
    1874:	ba d0 80 00 00       	mov    $0x80d0,%edx
    1879:	83 c0 08             	add    $0x8,%eax
    187c:	e8 fc ff ff ff       	call   187d <regulatory_hint_11d+0x18c>
    1881:	85 c0                	test   %eax,%eax
    1883:	89 c7                	mov    %eax,%edi
    1885:	0f 84 e6 01 00 00    	je     1a71 <regulatory_hint_11d+0x380>
    188b:	8b 55 d0             	mov    -0x30(%ebp),%edx
    188e:	89 10                	mov    %edx,(%eax)
    1890:	8a 45 df             	mov    -0x21(%ebp),%al
    1893:	88 47 04             	mov    %al,0x4(%edi)
    1896:	8a 55 de             	mov    -0x22(%ebp),%dl
    1899:	88 57 05             	mov    %dl,0x5(%edi)
    189c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
    18a3:	e9 a7 00 00 00       	jmp    194f <regulatory_hint_11d+0x25e>
    18a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
    18ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
    18ae:	83 e8 03             	sub    $0x3,%eax
    18b1:	89 45 cc             	mov    %eax,-0x34(%ebp)
    18b4:	80 7a fd c8          	cmpb   $0xc8,-0x3(%edx)
    18b8:	0f 87 89 00 00 00    	ja     1947 <regulatory_hint_11d+0x256>
    18be:	6b 45 d8 18          	imul   $0x18,-0x28(%ebp),%eax
    18c2:	8d 04 07             	lea    (%edi,%eax,1),%eax
    18c5:	8d 58 08             	lea    0x8(%eax),%ebx
    18c8:	83 c0 14             	add    $0x14,%eax
    18cb:	89 45 c8             	mov    %eax,-0x38(%ebp)
    18ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    18d1:	89 43 14             	mov    %eax,0x14(%ebx)
    18d4:	8a 42 fd             	mov    -0x3(%edx),%al
    18d7:	8b 55 cc             	mov    -0x34(%ebp),%edx
    18da:	3c 0e                	cmp    $0xe,%al
    18dc:	8a 4a 01             	mov    0x1(%edx),%cl
    18df:	77 0b                	ja     18ec <regulatory_hint_11d+0x1fb>
    18e1:	0f b6 d1             	movzbl %cl,%edx
    18e4:	0f b6 c0             	movzbl %al,%eax
    18e7:	8d 34 02             	lea    (%edx,%eax,1),%esi
    18ea:	eb 0a                	jmp    18f6 <regulatory_hint_11d+0x205>
    18ec:	0f b6 d0             	movzbl %al,%edx
    18ef:	0f b6 c1             	movzbl %cl,%eax
    18f2:	8d 74 82 fc          	lea    -0x4(%edx,%eax,4),%esi
    18f6:	8b 55 cc             	mov    -0x34(%ebp),%edx
    18f9:	0f b6 02             	movzbl (%edx),%eax
    18fc:	e8 fc ff ff ff       	call   18fd <regulatory_hint_11d+0x20c>
    1901:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
    1907:	2d 10 27 00 00       	sub    $0x2710,%eax
    190c:	89 03                	mov    %eax,(%ebx)
    190e:	89 f0                	mov    %esi,%eax
    1910:	e8 fc ff ff ff       	call   1911 <regulatory_hint_11d+0x220>
    1915:	c7 43 08 40 9c 00 00 	movl   $0x9c40,0x8(%ebx)
    191c:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
    1922:	05 10 27 00 00       	add    $0x2710,%eax
    1927:	89 43 04             	mov    %eax,0x4(%ebx)
    192a:	8b 45 c8             	mov    -0x38(%ebp),%eax
    192d:	c7 00 10 27 00 00    	movl   $0x2710,(%eax)
    1933:	c7 40 04 10 27 00 00 	movl   $0x2710,0x4(%eax)
    193a:	ff 45 d8             	incl   -0x28(%ebp)
    193d:	83 7d d8 20          	cmpl   $0x20,-0x28(%ebp)
    1941:	76 04                	jbe    1947 <regulatory_hint_11d+0x256>
    1943:	0f 0b                	ud2a   
    1945:	eb fe                	jmp    1945 <regulatory_hint_11d+0x254>
    1947:	80 6d ef 03          	subb   $0x3,-0x11(%ebp)
    194b:	83 45 e8 03          	addl   $0x3,-0x18(%ebp)
    194f:	8a 45 ef             	mov    -0x11(%ebp),%al
    1952:	04 03                	add    $0x3,%al
    1954:	3c 02                	cmp    $0x2,%al
    1956:	0f 87 4c ff ff ff    	ja     18a8 <regulatory_hint_11d+0x1b7>
    195c:	a1 00 00 00 00       	mov    0x0,%eax
    1961:	48                   	dec    %eax
    1962:	75 11                	jne    1975 <regulatory_hint_11d+0x284>
    1964:	6a 00                	push   $0x0
    1966:	6a 4e                	push   $0x4e
    1968:	68 13 00 00 00       	push   $0x13
    196d:	e8 fc ff ff ff       	call   196e <regulatory_hint_11d+0x27d>
    1972:	83 c4 0c             	add    $0xc,%esp
    1975:	a1 04 00 00 00       	mov    0x4,%eax
    197a:	83 78 04 03          	cmpl   $0x3,0x4(%eax)
    197e:	75 57                	jne    19d7 <regulatory_hint_11d+0x2e6>
    1980:	8b 00                	mov    (%eax),%eax
    1982:	e8 fc ff ff ff       	call   1983 <regulatory_hint_11d+0x292>
    1987:	85 c0                	test   %eax,%eax
    1989:	74 4c                	je     19d7 <regulatory_hint_11d+0x2e6>
    198b:	3b 45 bc             	cmp    -0x44(%ebp),%eax
    198e:	74 0e                	je     199e <regulatory_hint_11d+0x2ad>
    1990:	8b 45 c0             	mov    -0x40(%ebp),%eax
    1993:	e8 87 ea ff ff       	call   41f <country_ie_integrity_changes>
    1998:	84 c0                	test   %al,%al
    199a:	75 3b                	jne    19d7 <regulatory_hint_11d+0x2e6>
    199c:	eb 20                	jmp    19be <regulatory_hint_11d+0x2cd>
    199e:	8b 45 c0             	mov    -0x40(%ebp),%eax
    19a1:	e8 79 ea ff ff       	call   41f <country_ie_integrity_changes>
    19a6:	84 c0                	test   %al,%al
    19a8:	75 2d                	jne    19d7 <regulatory_hint_11d+0x2e6>
    19aa:	6a 00                	push   $0x0
    19ac:	68 cc 06 00 00       	push   $0x6cc
    19b1:	68 00 00 00 00       	push   $0x0
    19b6:	e8 fc ff ff ff       	call   19b7 <regulatory_hint_11d+0x2c6>
    19bb:	83 c4 0c             	add    $0xc,%esp
    19be:	6a 00                	push   $0x0
    19c0:	68 38 07 00 00       	push   $0x738
    19c5:	68 00 00 00 00       	push   $0x0
    19ca:	e8 fc ff ff ff       	call   19cb <regulatory_hint_11d+0x2da>
    19cf:	83 c4 0c             	add    $0xc,%esp
    19d2:	e9 93 00 00 00       	jmp    1a6a <regulatory_hint_11d+0x379>
    19d7:	ba d0 80 00 00       	mov    $0x80d0,%edx
    19dc:	b8 e4 02 00 00       	mov    $0x2e4,%eax
    19e1:	e8 fc ff ff ff       	call   19e2 <regulatory_hint_11d+0x2f1>
    19e6:	8b 15 e8 02 00 00    	mov    0x2e8,%edx
    19ec:	83 3d 04 00 00 00 00 	cmpl   $0x0,0x4
    19f3:	89 55 e0             	mov    %edx,-0x20(%ebp)
    19f6:	89 c3                	mov    %eax,%ebx
    19f8:	74 2a                	je     1a24 <regulatory_hint_11d+0x333>
    19fa:	8b 35 08 00 00 00    	mov    0x8,%esi
    1a00:	85 f6                	test   %esi,%esi
    1a02:	74 20                	je     1a24 <regulatory_hint_11d+0x333>
    1a04:	68 d0 80 00 00       	push   $0x80d0
    1a09:	89 da                	mov    %ebx,%edx
    1a0b:	ff 75 e0             	pushl  -0x20(%ebp)
    1a0e:	b8 d7 19 00 00       	mov    $0x19d7,%eax
    1a13:	b9 1c 00 00 00       	mov    $0x1c,%ecx
    1a18:	ff 16                	call   *(%esi)
    1a1a:	83 c6 04             	add    $0x4,%esi
    1a1d:	83 3e 00             	cmpl   $0x0,(%esi)
    1a20:	58                   	pop    %eax
    1a21:	5a                   	pop    %edx
    1a22:	eb de                	jmp    1a02 <regulatory_hint_11d+0x311>
    1a24:	85 db                	test   %ebx,%ebx
    1a26:	74 42                	je     1a6a <regulatory_hint_11d+0x379>
    1a28:	8b 45 bc             	mov    -0x44(%ebp),%eax
    1a2b:	89 3d 0c 00 00 00    	mov    %edi,0xc
    1a31:	e8 fc ff ff ff       	call   1a32 <regulatory_hint_11d+0x341>
    1a36:	89 03                	mov    %eax,(%ebx)
    1a38:	8a 47 04             	mov    0x4(%edi),%al
    1a3b:	88 43 08             	mov    %al,0x8(%ebx)
    1a3e:	8a 47 05             	mov    0x5(%edi),%al
    1a41:	c7 43 04 03 00 00 00 	movl   $0x3,0x4(%ebx)
    1a48:	88 43 09             	mov    %al,0x9(%ebx)
    1a4b:	8b 45 c0             	mov    -0x40(%ebp),%eax
    1a4e:	89 43 0c             	mov    %eax,0xc(%ebx)
    1a51:	b8 00 00 00 00       	mov    $0x0,%eax
    1a56:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    1a59:	89 53 10             	mov    %edx,0x10(%ebx)
    1a5c:	e8 fc ff ff ff       	call   1a5d <regulatory_hint_11d+0x36c>
    1a61:	89 d8                	mov    %ebx,%eax
    1a63:	e8 c3 f4 ff ff       	call   f2b <queue_regulatory_request>
    1a68:	eb 11                	jmp    1a7b <regulatory_hint_11d+0x38a>
    1a6a:	89 f8                	mov    %edi,%eax
    1a6c:	e8 fc ff ff ff       	call   1a6d <regulatory_hint_11d+0x37c>
    1a71:	b8 00 00 00 00       	mov    $0x0,%eax
    1a76:	e8 fc ff ff ff       	call   1a77 <regulatory_hint_11d+0x386>
    1a7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1a7e:	5b                   	pop    %ebx
    1a7f:	5e                   	pop    %esi
    1a80:	5f                   	pop    %edi
    1a81:	5d                   	pop    %ebp
    1a82:	c3                   	ret    

Disassembly of section .altinstr_replacement:

00000000 <.altinstr_replacement>:
   0:	0f 18 00             	prefetchnta (%eax)
   3:	0f 18 00             	prefetchnta (%eax)
   6:	0f 18 00             	prefetchnta (%eax)

--------------050805070301050509070409--
