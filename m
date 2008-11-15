Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:37718 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbYKOGaF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2008 01:30:05 -0500
Received: by yw-out-2324.google.com with SMTP id 9so760839ywe.1
        for <linux-wireless@vger.kernel.org>; Fri, 14 Nov 2008 22:30:04 -0800 (PST)
Message-ID: <449c10960811142230g3b0d0197s5cb26164136e3cf4@mail.gmail.com> (sfid-20081115_073027_271385_420C76C7)
Date: Sat, 15 Nov 2008 00:30:04 -0600
From: "Dan McGee" <dpmcgee@gmail.com>
Subject: Re: Kernel oops when loading ath5k from compat-wireless in 2.6.27
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Sujith <m.sujith@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Michael Buesch" <mb@bu3sch.de>,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <449c10960811141857u2b0c4153h3735545dbec7ef8b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890811141029q24ad722fi6a7ae1e7dcd463bd@mail.gmail.com>
	 <449c10960811141133o6d34c53fke3894a32cc1e5b8b@mail.gmail.com>
	 <b6c5339f0811141233g38086cc0ybb69eebdbab7ae60@mail.gmail.com>
	 <43e72e890811141241k7ae83fc3qe90e2e42d61b8df6@mail.gmail.com>
	 <43e72e890811141313t33b6a3edo86488bea9a7b3371@mail.gmail.com>
	 <449c10960811141625o171d1e31v974d2f921f5a825@mail.gmail.com>
	 <20081115003608.GK27642@tesla>
	 <449c10960811141805w428df33ak2f98651abb7403e6@mail.gmail.com>
	 <20081115022913.GC10702@hash.localnet>
	 <449c10960811141857u2b0c4153h3735545dbec7ef8b@mail.gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 14, 2008 at 8:57 PM, Dan McGee <dpmcgee@gmail.com> wrote:
>
> BUG: unable to handle kernel NULL pointer dereference at 00000082
> IP: [<7818ca71>] sysfs_find_dirent+0x9/0x23
> Oops: 0000 [#1] PREEMPT
> Modules linked in: ath5k(+) mac80211
>
> Pid: 818 comm: modprobe Not tainted (2.6.27.6eee #1)
> EIP: 0060:[<7818ca71>] EFLAGS: 00010206 CPU: 0
> EIP is at sysfs_find_dirent+0x9/0x23
> EAX: 00000001 EBX: 00000072 ECX: 00000001 EDX: b730b4f0
> ESI: b730b4f0 EDI: fffffff4 EBP: b7311490 ESP: b73ffd34
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Stack: <<<i'm too lazy>>>>
> Call Trace:
>  [<7818cb39>]: __sysfs_add_one+0x10/0x69
>  [<7818cba2>]: sysfs_add_one+0x9/0x2f
>  [<7818d0bc>]: create_dir+0x3c/0x62
>  sysfs_create_dir+0x29/0x3b
>  kobject_get
>  kobject_add_internal
>  kobject_add
>  device_add+0x75/0x456
>  apic_timer_interrupt+0x28/0x30
>  strlcpy+0x11/0x3e
>  register_netdevice+0x1f1/0x31a
>  ieee80211_register_hw+0x1eb/0x2d0 [mac80211]
>  ath5k_pci_probe+0xc27/0x1150 [ath5k]
>  find_inode
>  pci_device_probe
>  driver_probe_device
>  .......
>  init_ath5k_pci [ath5k]
>  .......
>  ==============
> Code: dd 85 c0 53 89 c3 74 16 83 38 00 75 0f ba 82 00 00 00 b8 f7 75
> 3c 78 e8 70 da f8 ff ff 03 89 d8 5b c3 56 89 d6 53 8b 58 18 eb 11 <8b>
> 43 10 89 f2 e8 34 cc 04 00 85 c0 74 07 8b 5b 0c 85 db 75 eb
>
> $ AFLAGS=--32 scripts/decodecode < /tmp/oops.txt
> Code: dd 85 c0 53 89 c3 74 16 83 38 00 75 0f ba 82 00 00 00 b8 f7 75
> 3c 78 e8 70 da f8 ff ff 03 89 d8 5b c3 56 89 d6 53 8b 58 18 eb 11 <8b>
> 43 10 89 f2 e8 34 cc 04 00 85 c0 74 07 8b 5b 0c 85 db 75 eb
>
> /tmp/tmp.xJNdgiQwSL.o:     file format elf32-i386
>
> Disassembly of section .text:
>
> 00000000 <.text>:
>   0:   dd 85 c0 53 89 c3       fldl   -0x3c76ac40(%ebp)
>   6:   74 16                   je     0x1e
>   8:   83 38 00                cmpl   $0x0,(%eax)
>   b:   75 0f                   jne    0x1c
>   d:   ba 82 00 00 00          mov    $0x82,%edx
>  12:   b8 f7 75 3c 78          mov    $0x783c75f7,%eax
>  17:   e8 70 da f8 ff          call   0xfff8da8c
>  1c:   ff 03                   incl   (%ebx)
>  1e:   89 d8                   mov    %ebx,%eax
>  20:   5b                      pop    %ebx
>  21:   c3                      ret
>  22:   56                      push   %esi
>  23:   89 d6                   mov    %edx,%esi
>  25:   53                      push   %ebx
>  26:   8b 58 18                mov    0x18(%eax),%ebx
>  29:   eb 11                   jmp    0x3c
>
> /tmp/tmp.xJNdgiQwSL.o:     file format elf32-i386
>
> Disassembly of section .text:
>
> 00000000 <.text>:
>   0:   8b 43 10                mov    0x10(%ebx),%eax
>   3:   89 f2                   mov    %esi,%edx
>   5:   e8 34 cc 04 00          call   0x4cc3e
>   a:   85 c0                   test   %eax,%eax
>   c:   74 07                   je     0x15
>   e:   8b 5b 0c                mov    0xc(%ebx),%ebx
>  11:   85 db                   test   %ebx,%ebx
>  13:   75 eb                   jne    0x0

And I had the code completely wrong, oops. Looks like we are bailing
on the strcmp call in this function or something along those lines? I
wish I could be a bigger help with debugging this stuff.

-Dan

000001bc <sysfs_find_dirent>:
 *      RETURNS:
 *      Pointer to sysfs_dirent if found, NULL if not.
 */
struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
                                      const unsigned char *name)
{
 1bc:   56                      push   %esi
 1bd:   89 d6                   mov    %edx,%esi
 1bf:   53                      push   %ebx
       struct sysfs_dirent *sd;

       for (sd = parent_sd->s_dir.children; sd; sd = sd->s_sibling)
 1c0:   8b 58 18                mov    0x18(%eax),%ebx
 1c3:   eb 11                   jmp    1d6 <sysfs_find_dirent+0x1a>
               if (!strcmp(sd->s_name, name))
 1c5:   8b 43 10                mov    0x10(%ebx),%eax
 1c8:   89 f2                   mov    %esi,%edx
 1ca:   e8 fc ff ff ff          call   1cb <sysfs_find_dirent+0xf>
 1cf:   85 c0                   test   %eax,%eax
 1d1:   74 07                   je     1da <sysfs_find_dirent+0x1e>
struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
                                      const unsigned char *name)
{
       struct sysfs_dirent *sd;

       for (sd = parent_sd->s_dir.children; sd; sd = sd->s_sibling)
 1d3:   8b 5b 0c                mov    0xc(%ebx),%ebx
 1d6:   85 db                   test   %ebx,%ebx
 1d8:   75 eb                   jne    1c5 <sysfs_find_dirent+0x9>
               if (!strcmp(sd->s_name, name))
                       return sd;
       return NULL;
}
 1da:   89 d8                   mov    %ebx,%eax
 1dc:   5b                      pop    %ebx
 1dd:   5e                      pop    %esi
 1de:   c3                      ret
