Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:34636 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751059AbdG3IRn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Jul 2017 04:17:43 -0400
Received: by mail-it0-f44.google.com with SMTP id v205so10728626itf.1
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jul 2017 01:17:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170730072258.hhlwwqkdxrew4dmc@angus>
References: <20170730072258.hhlwwqkdxrew4dmc@angus>
From: Emmanuel Grumbach <egrumbach@gmail.com>
Date: Sun, 30 Jul 2017 11:17:41 +0300
Message-ID: <CANUX_P1PC66Ukrk=02K3=4Dm1ptTkme=U+feHCEgGb3e3rDG9g@mail.gmail.com> (sfid-20170730_101811_176624_0C5533A2)
Subject: Re: System freezes when send packet to mon device in TX_RING mode
To: angus <vadim4j@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 30, 2017 at 10:22 AM, angus <vadim4j@gmail.com> wrote:
>
> Hi Wifi-Devs,

So you seem to be using an old Intel device.
What you can do is to use netconsole to send your kernel output to a
separate machine. This way you'll be able to collect logs.
Running in a VM is also an option.

>
> I got the full system freeze when tried to send rtap packet via monitor
> interface with
> TX_RING mode using trafgen tool (example of packet is below):
>
>     # it sends 1 packet via monitor wlan0 interface in TX_RING mode
>     trafgen/trafgen -i ~/pcap/rtap.cfg -o wlan0 -n 1
>
> after that system totally freezes so I can only reboot system
> via power button.
>
> But when I run the same command w/o using TX_RING on this
> interface then everything is OK:
>
>     trafgen/trafgen -i ~/pcap/rtap.cfg -o wlan0 -n 1
>
> Would you suggest some debugging approaches how to debug
> such issue when system is totally freezed ?
> Or may you please point some references to investigate the
> issue ?
>
> I wonder what may happen to full stuck the system.
>
> Below I provided some info which may help.
>
> I provided an strace of sending the packet via regular eth
> interface to demonstrate how interface
> is actually configured in TX_RING mode by trafgen util.
>
> Thanks,
> Vadim Kochan
>
> --------------------------------[Sys Info]---------------------
> Thinkpad x230
> Linux angus 4.8.0-59-generic #64-Ubuntu SMP Thu Jun 29 19:38:34 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
>
> --------------------------------[monitor setup]--------------------------
> #!/bin/bash
> DEV=wlp3s0
>
> sudo iw dev $DEV interface add $1 type monitor
> sudo ifconfig $DEV down
> sudo ifconfig $1 up
> sudo iw dev $1 set channel 1
> sudo ifconfig $DEV down
>
> --------------------------------[packet in trafgen's format]---------------------------------------------------------------------------
> {
>   0x00, 0x00, 0x18, 0x00, 0x0f, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
>   0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x08, 0x02, 0xff, 0xff, 0x01, 0x23,
>   0x45, 0x67, 0x89, 0xab, 0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0x01, 0x23, 0x45, 0x67, 0x89,
>   0xab, 0x00, 0x00, 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00, 0x08, 0x00, 0x45, 0x00, 0x00, 0x1c,
>   0x00, 0x00, 0x40, 0x00, 0x40, 0x11, 0x8f, 0xd2, 0xa9, 0xfe, 0x01, 0x01, 0xff, 0xff, 0xff,
>   0xff, 0xc5, 0x49, 0xc5, 0x49, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> }
>
> ------------------------------- [strace of sending via eth iface] -----------------------------------------
> angus@angus:~/src/netsniff-ng$ sudo strace -f trafgen/trafgen -i ~/pcap/rtap.cfg -o wlp3s0 -n 1
> execve("trafgen/trafgen", ["trafgen/trafgen", "-i", "/home/angus/pcap/rtap.cfg", "-o", "wlp3s0", "-n", "1"], [/* 27 vars */]) = 0
> brk(NULL)                               = 0x557b13f71000
> access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
> mmap(NULL, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f7dcdd2a000
> access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
> open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
> fstat(3, {st_mode=S_IFREG|0644, st_size=124132, ...}) = 0
> mmap(NULL, 124132, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f7dcdd0b000
> close(3)                                = 0
> access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
> open("/lib/x86_64-linux-gnu/libm.so.6", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20W\0\0\0\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0644, st_size=1088952, ...}) = 0
> mmap(NULL, 3178744, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f7dcd7ff000
> mprotect(0x7f7dcd907000, 2093056, PROT_NONE) = 0
> mmap(0x7f7dcdb06000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x107000) = 0x7f7dcdb06000
> close(3)                                = 0
> access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
> open("/lib/x86_64-linux-gnu/libnl-3.so.200", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\200r\0\0\0\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0644, st_size=125664, ...}) = 0
> mmap(NULL, 2221096, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f7dcd5e0000
> mprotect(0x7f7dcd5fd000, 2093056, PROT_NONE) = 0
> mmap(0x7f7dcd7fc000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1c000) = 0x7f7dcd7fc000
> close(3)                                = 0
> access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
> open("/lib/x86_64-linux-gnu/libnl-genl-3.so.200", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0000 \0\0\0\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0644, st_size=23792, ...}) = 0
> mmap(NULL, 2118856, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f7dcd3da000
> mprotect(0x7f7dcd3df000, 2093056, PROT_NONE) = 0
> mmap(0x7f7dcd5de000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x4000) = 0x7f7dcd5de000
> close(3)                                = 0
> access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
> open("/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20\5\2\0\0\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=1856752, ...}) = 0
> mmap(NULL, 3959200, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f7dcd013000
> mprotect(0x7f7dcd1d1000, 2093056, PROT_NONE) = 0
> mmap(0x7f7dcd3d0000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1bd000) = 0x7f7dcd3d0000
> mmap(0x7f7dcd3d6000, 14752, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f7dcd3d6000
> close(3)                                = 0
> access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
> open("/lib/x86_64-linux-gnu/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\240`\0\0\0\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=142400, ...}) = 0
> mmap(NULL, 2217000, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f7dccdf5000
> mprotect(0x7f7dcce0d000, 2097152, PROT_NONE) = 0
> mmap(0x7f7dcd00d000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x18000) = 0x7f7dcd00d000
> mmap(0x7f7dcd00f000, 13352, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f7dcd00f000
> close(3)                                = 0
> mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f7dcdd09000
> arch_prctl(ARCH_SET_FS, 0x7f7dcdd0a400) = 0
> mprotect(0x7f7dcd3d0000, 16384, PROT_READ) = 0
> mprotect(0x7f7dcd00d000, 4096, PROT_READ) = 0
> mprotect(0x7f7dcdb06000, 4096, PROT_READ) = 0
> mprotect(0x7f7dcd7fc000, 8192, PROT_READ) = 0
> mprotect(0x7f7dcd5de000, 4096, PROT_READ) = 0
> mprotect(0x557b1368b000, 8192, PROT_READ) = 0
> mprotect(0x7f7dcdd2d000, 4096, PROT_READ) = 0
> munmap(0x7f7dcdd0b000, 124132)          = 0
> set_tid_address(0x7f7dcdd0a6d0)         = 2870
> set_robust_list(0x7f7dcdd0a6e0, 24)     = 0
> rt_sigaction(SIGRTMIN, {0x7f7dccdfab40, [], SA_RESTORER|SA_SIGINFO, 0x7f7dcce06630}, NULL, 8) = 0
> rt_sigaction(SIGRT_1, {0x7f7dccdfabd0, [], SA_RESTORER|SA_RESTART|SA_SIGINFO, 0x7f7dcce06630}, NULL, 8) = 0
> rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
> getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM64_INFINITY}) = 0
> brk(NULL)                               = 0x557b13f71000
> brk(0x557b13f92000)                     = 0x557b13f92000
> open("/proc/net/psched", O_RDONLY)      = 3
> fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
> read(3, "000003e8 00000040 000f4240 3b9ac"..., 1024) = 36
> close(3)                                = 0
> open("/sys/devices/system/cpu/online", O_RDONLY|O_CLOEXEC) = 3
> read(3, "0-3\n", 8192)                  = 4
> close(3)                                = 0
> getuid()                                = 0
> getgid()                                = 0
> rt_sigaction(SIGINT, {0x557b134700f0, ~[RTMIN RT_1], SA_RESTORER|SA_RESTART, 0x7f7dcd048860}, NULL, 8) = 0
> rt_sigaction(SIGQUIT, {0x557b134700f0, ~[RTMIN RT_1], SA_RESTORER|SA_RESTART, 0x7f7dcd048860}, NULL, 8) = 0
> rt_sigaction(SIGTERM, {0x557b134700f0, ~[RTMIN RT_1], SA_RESTORER|SA_RESTART, 0x7f7dcd048860}, NULL, 8) = 0
> rt_sigaction(SIGHUP, {0x557b134700f0, ~[RTMIN RT_1], SA_RESTORER|SA_RESTART, 0x7f7dcd048860}, NULL, 8) = 0
> open("/proc/sys/net/core/rmem_max", O_RDONLY) = 3
> read(3, "212992\n", 64)                 = 7
> close(3)                                = 0
> open("/proc/sys/net/core/rmem_max", O_WRONLY) = 3
> write(3, "104857600", 9)                = 9
> close(3)                                = 0
> open("/proc/sys/net/core/rmem_default", O_RDONLY) = 3
> read(3, "212992\n", 64)                 = 7
> close(3)                                = 0
> open("/proc/sys/net/core/rmem_default", O_WRONLY) = 3
> write(3, "4194304", 7)                  = 7
> close(3)                                = 0
> open("/proc/sys/net/core/wmem_max", O_RDONLY) = 3
> read(3, "212992\n", 64)                 = 7
> close(3)                                = 0
> open("/proc/sys/net/core/wmem_max", O_WRONLY) = 3
> write(3, "104857600", 9)                = 9
> close(3)                                = 0
> open("/proc/sys/net/core/wmem_default", O_RDONLY) = 3
> read(3, "212992\n", 64)                 = 7
> close(3)                                = 0
> open("/proc/sys/net/core/wmem_default", O_WRONLY) = 3
> write(3, "4194304", 7)                  = 7
> close(3)                                = 0
> mlockall(MCL_CURRENT|MCL_FUTURE)        = 0
> socket(AF_INET, SOCK_DGRAM, IPPROTO_IP) = 3
> ioctl(3, SIOCGIFMTU, {ifr_name="wlp3s0", ifr_mtu=1500}) = 0
> close(3)                                = 0
> socket(AF_INET, SOCK_DGRAM, IPPROTO_IP) = 3
> ioctl(3, SIOCGIFINDEX, {ifr_name="wlp3s0", }) = 0
> close(3)                                = 0
> socket(AF_INET, SOCK_DGRAM, IPPROTO_IP) = 3
> ioctl(3, SIOCGIFHWADDR, {ifr_name="wlp3s0", ifr_hwaddr=6c:88:14:ac:51:e4}) = 0
> close(3)                                = 0
> socket(AF_PACKET, SOCK_RAW, 0)          = 3
> open("/sys/class/net/wlp3s0/device/irq", O_RDONLY) = 4
> fstat(4, {st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
> read(4, "30\n", 4096)                   = 3
> close(4)                                = 0
> open("/proc/irq/30/smp_affinity_list", O_RDONLY) = 4
> read(4, "1\n", 128)                     = 2
> close(4)                                = 0
> open("/proc/irq/30/smp_affinity_list", O_WRONLY) = 4
> write(4, "0-0\n", 4)                    = 4
> close(4)                                = 0
> open(".tmp_mmap.K27ZDW", O_RDWR|O_CREAT|O_EXCL|O_TRUNC, 0600) = 4
> write(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 64) = 64
> mmap(NULL, 64, PROT_READ|PROT_WRITE, MAP_SHARED, 4, 0) = 0x7f7dcdd29000
> close(4)                                = 0
> unlink(".tmp_mmap.K27ZDW")              = 0
> clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7f7dcdd0a6d0) = 2872
> wait4(-1, strace: Process 2872 attached
>  <unfinished ...>
> [pid  2872] set_robust_list(0x7f7dcdd0a6e0, 24) = 0
> [pid  2872] open("/dev/urandom", O_RDONLY) = 4
> [pid  2872] read(4, "\235y\311\370", 4) = 4
> [pid  2872] close(4)                    = 0
> [pid  2872] sched_setaffinity(2872, 128, [0]) = 0
> [pid  2872] access("/home/angus/pcap/rtap.cfg", R_OK) = 0
> [pid  2872] open("/home/angus/pcap/rtap.cfg", O_RDONLY) = 4
> [pid  2872] ioctl(4, TCGETS, 0x7ffdaad00f80) = -1 ENOTTY (Inappropriate ioctl for device)
> [pid  2872] fstat(4, {st_mode=S_IFREG|0644, st_size=550, ...}) = 0
> [pid  2872] read(4, "{\n  0x00, 0x00, 0x18, 0x00, 0x0f"..., 8192) = 550
> [pid  2872] read(4, "", 4096)           = 0
> [pid  2872] read(4, "", 8192)           = 0
> [pid  2872] ioctl(4, TCGETS, 0x7ffdaad00f80) = -1 ENOTTY (Inappropriate ioctl for device)
> [pid  2872] close(4)                    = 0
> [pid  2872] fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 5), ...}) = 0
> [pid  2872] write(1, "     1 packets to schedule\n", 27     1 packets to schedule
> ) = 27
> [pid  2872] write(1, "    88 bytes in total\n", 22    88 bytes in total
> ) = 22
> [pid  2872] write(1, "Running! Hang up with ^C!\n", 26Running! Hang up with ^C!
> ) = 26
> [pid  2872] write(1, "\n", 1
> )           = 1
> [pid  2872] setsockopt(3, SOL_PACKET, PACKET_QDISC_BYPASS, [1], 4) = 0
> [pid  2872] setsockopt(3, SOL_SOCKET, SO_PRIORITY, [512], 4) = 0
> [pid  2872] setsockopt(3, SOL_PACKET, PACKET_LOSS, [1], 4) = 0
> [pid  2872] setsockopt(3, SOL_PACKET, PACKET_VERSION, [1], 4) = 0
> [pid  2872] setsockopt(3, SOL_PACKET, PACKET_TX_RING, {block_size=16384, block_nr=32, frame_size=2048, frame_nr=256}, 16) = 0
> [pid  2872] mmap(NULL, 524288, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE|MAP_LOCKED, 3, 0) = 0x7f7dcdc89000
> [pid  2872] bind(3, {sa_family=AF_PACKET, proto=0000, if3, pkttype=PACKET_HOST, addr(0)={0, }, 20) = 0
> [pid  2872] setgid(0)                   = 0
> [pid  2872] setuid(0)                   = 0
> [pid  2872] sendto(3, NULL, 0, 0, NULL, 0) = 88
> [pid  2872] munmap(0x7f7dcdc89000, 524288) = 0
> [pid  2872] setsockopt(3, SOL_PACKET, PACKET_TX_RING, {block_size=0, block_nr=0, frame_size=0, frame_nr=0}, 16) = 0
> [pid  2872] munlockall()                = 0
> [pid  2872] munmap(0x7f7dcdd29000, 64)  = 0
> [pid  2872] open("/proc/irq/30/smp_affinity_list", O_WRONLY) = 4
> [pid  2872] write(4, "1\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 128) = 128
> [pid  2872] close(4)                    = 0
> [pid  2872] exit_group(0)               = ?
> [pid  2872] +++ exited with 0 +++
> <... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 2872
> --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=2872, si_uid=0, si_status=0, si_utime=0, si_stime=0} ---
> open("/proc/sys/net/core/rmem_max", O_WRONLY) = 4
> write(4, "212992", 6)                   = 6
> close(4)                                = 0
> open("/proc/sys/net/core/rmem_default", O_WRONLY) = 4
> write(4, "212992", 6)                   = 6
> close(4)                                = 0
> open("/proc/sys/net/core/wmem_max", O_WRONLY) = 4
> write(4, "212992", 6)                   = 6
> close(4)                                = 0
> open("/proc/sys/net/core/wmem_default", O_WRONLY) = 4
> write(4, "212992", 6)                   = 6
> close(4)                                = 0
> fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 5), ...}) = 0
> write(1, "\n", 1
> )                       = 1
>            1 packets outgoingets outgoing\n", 31
> ) = 31
>           88 bytes outgoingtes outgoing\n", 29
> ) = 29
>            0 sec, 1 usec on CPU0 (1 packets)..., 46
> ) = 46
> munlockall()                            = 0
> munmap(0x7f7dcdd29000, 64)              = 0
> open("/proc/irq/30/smp_affinity_list", O_WRONLY) = 4
> write(4, "1\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 128) = 128
> close(4)                                = 0
> exit_group(0)                           = ?
> +++ exited with 0 +++
>
> ---------------------------------[pci info]------------------------------------------
> angus@angus:~$ lspci
> 00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM Controller (rev 09)
> 00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core processor Graphics Controller (rev 09)
> 00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller (rev 04)
> 00:16.0 Communication controller: Intel Corporation 7 Series/C210 Series Chipset Family MEI Controller #1 (rev 04)
> 00:16.3 Serial controller: Intel Corporation 7 Series/C210 Series Chipset Family KT Controller (rev 04)
> 00:19.0 Ethernet controller: Intel Corporation 82579LM Gigabit Network Connection (rev 04)
> 00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2 (rev 04)
> 00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset Family High Definition Audio Controller (rev 04)
> 00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 1 (rev c4)
> 00:1c.1 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 2 (rev c4)
> 00:1c.2 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 3 (rev c4)
> 00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1 (rev 04)
> 00:1f.0 ISA bridge: Intel Corporation QM77 Express Chipset LPC Controller (rev 04)
> 00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family 6-port SATA Controller [AHCI mode] (rev 04)
> 00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family SMBus Controller (rev 04)
> 02:00.0 System peripheral: Ricoh Co Ltd MMC/SD Host Controller (rev 07)
> 03:00.0 Network controller: Intel Corporation Centrino Advanced-N 6205 [Taylor Peak] (rev 34)
>
> ----------------------------------[kernel module info]------------------------------------------
> angus@angus:~$ modinfo iwlwifi
> filename:       /lib/modules/4.8.0-59-generic/kernel/drivers/net/wireless/intel/iwlwifi/iwlwifi.ko
> license:        GPL
> author:         Copyright(c) 2003- 2015 Intel Corporation <linuxwifi@intel.com>
> description:    Intel(R) Wireless WiFi driver for Linux
> firmware:       iwlwifi-100-5.ucode
> firmware:       iwlwifi-1000-5.ucode
> firmware:       iwlwifi-135-6.ucode
> firmware:       iwlwifi-105-6.ucode
> firmware:       iwlwifi-2030-6.ucode
> firmware:       iwlwifi-2000-6.ucode
> firmware:       iwlwifi-5150-2.ucode
> firmware:       iwlwifi-5000-5.ucode
> firmware:       iwlwifi-6000g2b-IWL6000G2B_UCODE_API_MAX.ucode
> firmware:       iwlwifi-6000g2a-6.ucode
> firmware:       iwlwifi-6050-5.ucode
> firmware:       iwlwifi-6000-6.ucode
> firmware:       iwlwifi-7265D-24.ucode
> firmware:       iwlwifi-7265-17.ucode
> firmware:       iwlwifi-3168-24.ucode
> firmware:       iwlwifi-3160-17.ucode
> firmware:       iwlwifi-7260-17.ucode
> firmware:       iwlwifi-8265-24.ucode
> firmware:       iwlwifi-8000C--24.ucode
> firmware:       iwlwifi-9260-th-a0-lc-a0--24.ucode
> firmware:       iwlwifi-9260-th-a0-jf-a0--24.ucode
> firmware:       iwlwifi-9000-pu-a0-lc-a0--24.ucode
> firmware:       iwlwifi-Qu-a0-jf-b0--24.ucode
> srcversion:     E7651FD3D9AF45F96CD8B2E
> alias:          pci:v00008086d00002720sv*sd00000A10bc*sc*i*
> alias:          pci:v00008086d00009DF0sv*sd00002A10bc*sc*i*
> alias:          pci:v00008086d00009DF0sv*sd00000710bc*sc*i*
> alias:          pci:v00008086d00002526sv*sd00001420bc*sc*i*
> alias:          pci:v00008086d00009DF0sv*sd00002010bc*sc*i*
> alias:          pci:v00008086d00009DF0sv*sd00000510bc*sc*i*
> alias:          pci:v00008086d00009DF0sv*sd00000000bc*sc*i*
> alias:          pci:v00008086d00009DF0sv*sd00000310bc*sc*i*
> alias:          pci:v00008086d00009DF0sv*sd00000610bc*sc*i*
> alias:          pci:v00008086d00009DF0sv*sd00000410bc*sc*i*
> alias:          pci:v00008086d00009DF0sv*sd00000210bc*sc*i*
> alias:          pci:v00008086d00009DF0sv*sd00000010bc*sc*i*
> alias:          pci:v00008086d00009DF0sv*sd00000A10bc*sc*i*
> alias:          pci:v00008086d00002526sv*sd00000010bc*sc*i*
> alias:          pci:v00008086d00002526sv*sd00000000bc*sc*i*
> alias:          pci:v00008086d000024FDsv*sd00000850bc*sc*i*
> alias:          pci:v00008086d000024FDsv*sd00000950bc*sc*i*
> alias:          pci:v00008086d000024FDsv*sd00000930bc*sc*i*
> alias:          pci:v00008086d000024FDsv*sd00000910bc*sc*i*
> alias:          pci:v00008086d000024FDsv*sd00008130bc*sc*i*
> alias:          pci:v00008086d000024FDsv*sd00009110bc*sc*i*
> alias:          pci:v00008086d000024FDsv*sd00000810bc*sc*i*
> alias:          pci:v00008086d000024FDsv*sd00008010bc*sc*i*
> alias:          pci:v00008086d000024FDsv*sd00008050bc*sc*i*
> alias:          pci:v00008086d000024FDsv*sd00008110bc*sc*i*
> alias:          pci:v00008086d000024FDsv*sd00009010bc*sc*i*
> alias:          pci:v00008086d000024FDsv*sd00000150bc*sc*i*
> alias:          pci:v00008086d000024FDsv*sd00000050bc*sc*i*
> alias:          pci:v00008086d000024FDsv*sd00001010bc*sc*i*
> alias:          pci:v00008086d000024FDsv*sd00000130bc*sc*i*
> alias:          pci:v00008086d000024FDsv*sd00001130bc*sc*i*
> alias:          pci:v00008086d000024FDsv*sd00001110bc*sc*i*
> alias:          pci:v00008086d000024FDsv*sd00000110bc*sc*i*
> alias:          pci:v00008086d000024FDsv*sd00000010bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00000000bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00000930bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00000950bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00000850bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00000910bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00000810bc*sc*i*
> alias:          pci:v00008086d000024F6sv*sd00000030bc*sc*i*
> alias:          pci:v00008086d000024F5sv*sd00000010bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00000044bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00000004bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00009150bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00009050bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00008150bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00008050bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00009132bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00008132bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00009130bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00008130bc*sc*i*
> alias:          pci:v00008086d000024F4sv*sd00009030bc*sc*i*
> alias:          pci:v00008086d000024F4sv*sd00008030bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00009110bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00009010bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00008110bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00008010bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd0000B0B0bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd0000D0B0bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd0000D050bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd0000C050bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd0000D010bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd0000C110bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd0000C010bc*sc*i*
> alias:          pci:v00008086d000024F4sv*sd00001030bc*sc*i*
> alias:          pci:v00008086d000024F4sv*sd00000030bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00001150bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00000150bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00001050bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00000250bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00000050bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00001110bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00001012bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00000012bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd000001F0bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00000110bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00001132bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00000132bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00001130bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00000130bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd000010B0bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00001010bc*sc*i*
> alias:          pci:v00008086d000024F3sv*sd00000010bc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd00009400bc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd00009000bc*sc*i*
> alias:          pci:v00008086d0000095Bsv*sd0000520Abc*sc*i*
> alias:          pci:v00008086d0000095Bsv*sd00005212bc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd00005F10bc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd00005490bc*sc*i*
> alias:          pci:v00008086d0000095Bsv*sd00005290bc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd00005590bc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd00005190bc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd00005090bc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd00005420bc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd0000502Abc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd00005020bc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd00009410bc*sc*i*
> alias:          pci:v00008086d0000095Bsv*sd00009310bc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd00009510bc*sc*i*
> alias:          pci:v00008086d0000095Bsv*sd00009200bc*sc*i*
> alias:          pci:v00008086d0000095Bsv*sd00009210bc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd00009112bc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd00009110bc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd0000900Abc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd00009012bc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd00009010bc*sc*i*
> alias:          pci:v00008086d0000095Bsv*sd00005202bc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd00005102bc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd00005002bc*sc*i*
> alias:          pci:v00008086d0000095Bsv*sd00005200bc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd0000500Abc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd00005000bc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd00001010bc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd00005400bc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd00005510bc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd00005410bc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd00005412bc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd00005012bc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd00005C10bc*sc*i*
> alias:          pci:v00008086d0000095Bsv*sd00005210bc*sc*i*
> alias:          pci:v00008086d0000095Bsv*sd00005302bc*sc*i*
> alias:          pci:v00008086d0000095Bsv*sd00005310bc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd00005100bc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd00005110bc*sc*i*
> alias:          pci:v00008086d0000095Asv*sd00005010bc*sc*i*
> alias:          pci:v00008086d000024FBsv*sd00000000bc*sc*i*
> alias:          pci:v00008086d000024FBsv*sd00002150bc*sc*i*
> alias:          pci:v00008086d000024FBsv*sd00002050bc*sc*i*
> alias:          pci:v00008086d000024FBsv*sd00002110bc*sc*i*
> alias:          pci:v00008086d000024FBsv*sd00002010bc*sc*i*
> alias:          pci:v00008086d00003165sv*sd00008110bc*sc*i*
> alias:          pci:v00008086d00003165sv*sd00008010bc*sc*i*
> alias:          pci:v00008086d00003166sv*sd00004210bc*sc*i*
> alias:          pci:v00008086d00003166sv*sd00004310bc*sc*i*
> alias:          pci:v00008086d00003165sv*sd00004110bc*sc*i*
> alias:          pci:v00008086d00003165sv*sd00004510bc*sc*i*
> alias:          pci:v00008086d00003165sv*sd00004410bc*sc*i*
> alias:          pci:v00008086d00003166sv*sd00004212bc*sc*i*
> alias:          pci:v00008086d00003165sv*sd00004012bc*sc*i*
> alias:          pci:v00008086d00003165sv*sd00004010bc*sc*i*
> alias:          pci:v00008086d000008B3sv*sd00001170bc*sc*i*
> alias:          pci:v00008086d000008B3sv*sd00001070bc*sc*i*
> alias:          pci:v00008086d000008B3sv*sd00008570bc*sc*i*
> alias:          pci:v00008086d000008B3sv*sd00008470bc*sc*i*
> alias:          pci:v00008086d000008B4sv*sd00008272bc*sc*i*
> alias:          pci:v00008086d000008B4sv*sd00008370bc*sc*i*
> alias:          pci:v00008086d000008B4sv*sd00008270bc*sc*i*
> alias:          pci:v00008086d000008B3sv*sd00008062bc*sc*i*
> alias:          pci:v00008086d000008B3sv*sd00008060bc*sc*i*
> alias:          pci:v00008086d000008B3sv*sd00008172bc*sc*i*
> alias:          pci:v00008086d000008B3sv*sd00008170bc*sc*i*
> alias:          pci:v00008086d000008B3sv*sd00008072bc*sc*i*
> alias:          pci:v00008086d000008B3sv*sd00008070bc*sc*i*
> alias:          pci:v00008086d000008B4sv*sd00000370bc*sc*i*
> alias:          pci:v00008086d000008B3sv*sd00000472bc*sc*i*
> alias:          pci:v00008086d000008B3sv*sd00000470bc*sc*i*
> alias:          pci:v00008086d000008B4sv*sd00000272bc*sc*i*
> alias:          pci:v00008086d000008B4sv*sd00000270bc*sc*i*
> alias:          pci:v00008086d000008B3sv*sd00000062bc*sc*i*
> alias:          pci:v00008086d000008B3sv*sd00000060bc*sc*i*
> alias:          pci:v00008086d000008B3sv*sd00000172bc*sc*i*
> alias:          pci:v00008086d000008B3sv*sd00000170bc*sc*i*
> alias:          pci:v00008086d000008B3sv*sd00000072bc*sc*i*
> alias:          pci:v00008086d000008B3sv*sd00000070bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd0000C420bc*sc*i*
> alias:          pci:v00008086d000008B2sv*sd0000C220bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd0000C02Abc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd0000C020bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd0000C360bc*sc*i*
> alias:          pci:v00008086d000008B2sv*sd0000C370bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd0000C560bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd0000C570bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd0000C462bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd0000C460bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd0000C472bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd0000C470bc*sc*i*
> alias:          pci:v00008086d000008B2sv*sd0000C262bc*sc*i*
> alias:          pci:v00008086d000008B2sv*sd0000C26Abc*sc*i*
> alias:          pci:v00008086d000008B2sv*sd0000C260bc*sc*i*
> alias:          pci:v00008086d000008B2sv*sd0000C272bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd0000CC60bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd0000CC70bc*sc*i*
> alias:          pci:v00008086d000008B2sv*sd0000C270bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd0000C760bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd0000C770bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd0000C162bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd0000C062bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd0000C160bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd0000C06Abc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd0000C060bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd0000C170bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd0000C072bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd0000C070bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd00004420bc*sc*i*
> alias:          pci:v00008086d000008B2sv*sd00004220bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd0000402Abc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd00004020bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd00005770bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd00005170bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd00005072bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd00005070bc*sc*i*
> alias:          pci:v00008086d000008B2sv*sd00004360bc*sc*i*
> alias:          pci:v00008086d000008B2sv*sd00004370bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd00004560bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd00004570bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd00004A6Cbc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd00004A6Ebc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd00004A70bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd0000486Ebc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd00004870bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd00004462bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd0000446Abc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd00004460bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd00004472bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd00004470bc*sc*i*
> alias:          pci:v00008086d000008B2sv*sd00004262bc*sc*i*
> alias:          pci:v00008086d000008B2sv*sd0000426Abc*sc*i*
> alias:          pci:v00008086d000008B2sv*sd00004260bc*sc*i*
> alias:          pci:v00008086d000008B2sv*sd00004272bc*sc*i*
> alias:          pci:v00008086d000008B2sv*sd00004270bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd00004162bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd00004062bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd00004160bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd0000406Abc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd00004060bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd00004C70bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd00004C60bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd00004170bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd00004072bc*sc*i*
> alias:          pci:v00008086d000008B1sv*sd00004070bc*sc*i*
> alias:          pci:v00008086d00000892sv*sd00000462bc*sc*i*
> alias:          pci:v00008086d00000893sv*sd00000262bc*sc*i*
> alias:          pci:v00008086d00000892sv*sd00000062bc*sc*i*
> alias:          pci:v00008086d00000894sv*sd00000822bc*sc*i*
> alias:          pci:v00008086d00000894sv*sd00000422bc*sc*i*
> alias:          pci:v00008086d00000895sv*sd00000222bc*sc*i*
> alias:          pci:v00008086d00000894sv*sd00000022bc*sc*i*
> alias:          pci:v00008086d0000088Fsv*sd00005260bc*sc*i*
> alias:          pci:v00008086d0000088Esv*sd00004860bc*sc*i*
> alias:          pci:v00008086d0000088Esv*sd0000446Abc*sc*i*
> alias:          pci:v00008086d0000088Esv*sd00004460bc*sc*i*
> alias:          pci:v00008086d0000088Fsv*sd0000426Abc*sc*i*
> alias:          pci:v00008086d0000088Fsv*sd00004260bc*sc*i*
> alias:          pci:v00008086d0000088Esv*sd0000406Abc*sc*i*
> alias:          pci:v00008086d0000088Esv*sd00004060bc*sc*i*
> alias:          pci:v00008086d00000887sv*sd00004462bc*sc*i*
> alias:          pci:v00008086d00000888sv*sd00004262bc*sc*i*
> alias:          pci:v00008086d00000887sv*sd00004062bc*sc*i*
> alias:          pci:v00008086d00000890sv*sd00004822bc*sc*i*
> alias:          pci:v00008086d00000890sv*sd00004422bc*sc*i*
> alias:          pci:v00008086d00000891sv*sd00004222bc*sc*i*
> alias:          pci:v00008086d00000890sv*sd00004022bc*sc*i*
> alias:          pci:v00008086d00000896sv*sd00005027bc*sc*i*
> alias:          pci:v00008086d00000896sv*sd00005025bc*sc*i*
> alias:          pci:v00008086d00000897sv*sd00005017bc*sc*i*
> alias:          pci:v00008086d00000897sv*sd00005015bc*sc*i*
> alias:          pci:v00008086d00000896sv*sd00005007bc*sc*i*
> alias:          pci:v00008086d00000896sv*sd00005005bc*sc*i*
> alias:          pci:v00008086d000008AEsv*sd00001027bc*sc*i*
> alias:          pci:v00008086d000008AEsv*sd00001025bc*sc*i*
> alias:          pci:v00008086d000008AFsv*sd00001017bc*sc*i*
> alias:          pci:v00008086d000008AFsv*sd00001015bc*sc*i*
> alias:          pci:v00008086d000008AEsv*sd00001007bc*sc*i*
> alias:          pci:v00008086d000008AEsv*sd00001005bc*sc*i*
> alias:          pci:v00008086d00000084sv*sd00001316bc*sc*i*
> alias:          pci:v00008086d00000084sv*sd00001216bc*sc*i*
> alias:          pci:v00008086d00000083sv*sd00001326bc*sc*i*
> alias:          pci:v00008086d00000083sv*sd00001226bc*sc*i*
> alias:          pci:v00008086d00000083sv*sd00001306bc*sc*i*
> alias:          pci:v00008086d00000083sv*sd00001206bc*sc*i*
> alias:          pci:v00008086d00000084sv*sd00001315bc*sc*i*
> alias:          pci:v00008086d00000084sv*sd00001215bc*sc*i*
> alias:          pci:v00008086d00000083sv*sd00001325bc*sc*i*
> alias:          pci:v00008086d00000083sv*sd00001225bc*sc*i*
> alias:          pci:v00008086d00000083sv*sd00001305bc*sc*i*
> alias:          pci:v00008086d00000083sv*sd00001205bc*sc*i*
> alias:          pci:v00008086d00000886sv*sd00001317bc*sc*i*
> alias:          pci:v00008086d00000886sv*sd00001315bc*sc*i*
> alias:          pci:v00008086d00000885sv*sd00001327bc*sc*i*
> alias:          pci:v00008086d00000885sv*sd00001325bc*sc*i*
> alias:          pci:v00008086d00000885sv*sd00001307bc*sc*i*
> alias:          pci:v00008086d00000885sv*sd00001305bc*sc*i*
> alias:          pci:v00008086d00000089sv*sd00001316bc*sc*i*
> alias:          pci:v00008086d00000089sv*sd00001311bc*sc*i*
> alias:          pci:v00008086d00000087sv*sd00001326bc*sc*i*
> alias:          pci:v00008086d00000087sv*sd00001321bc*sc*i*
> alias:          pci:v00008086d00000087sv*sd00001306bc*sc*i*
> alias:          pci:v00008086d00000087sv*sd00001301bc*sc*i*
> alias:          pci:v00008086d00000091sv*sd00005226bc*sc*i*
> alias:          pci:v00008086d00000091sv*sd00005225bc*sc*i*
> alias:          pci:v00008086d00000091sv*sd00005221bc*sc*i*
> alias:          pci:v00008086d00000091sv*sd00005207bc*sc*i*
> alias:          pci:v00008086d00000091sv*sd00005206bc*sc*i*
> alias:          pci:v00008086d00000091sv*sd00005205bc*sc*i*
> alias:          pci:v00008086d00000091sv*sd00005201bc*sc*i*
> alias:          pci:v00008086d00000090sv*sd00005216bc*sc*i*
> alias:          pci:v00008086d00000090sv*sd00005215bc*sc*i*
> alias:          pci:v00008086d00000090sv*sd00005211bc*sc*i*
> alias:          pci:v00008086d0000008Bsv*sd00005317bc*sc*i*
> alias:          pci:v00008086d0000008Bsv*sd00005315bc*sc*i*
> alias:          pci:v00008086d0000008Asv*sd00005327bc*sc*i*
> alias:          pci:v00008086d0000008Asv*sd00005325bc*sc*i*
> alias:          pci:v00008086d0000008Asv*sd00005307bc*sc*i*
> alias:          pci:v00008086d0000008Asv*sd00005305bc*sc*i*
> alias:          pci:v00008086d00000082sv*sd00001305bc*sc*i*
> alias:          pci:v00008086d00000082sv*sd00001304bc*sc*i*
> alias:          pci:v00008086d00000082sv*sd00004820bc*sc*i*
> alias:          pci:v00008086d00000085sv*sd0000C228bc*sc*i*
> alias:          pci:v00008086d00000085sv*sd0000C220bc*sc*i*
> alias:          pci:v00008086d00000082sv*sd0000C020bc*sc*i*
> alias:          pci:v00008086d00000085sv*sd00001316bc*sc*i*
> alias:          pci:v00008086d00000085sv*sd00001318bc*sc*i*
> alias:          pci:v00008086d00000085sv*sd00001311bc*sc*i*
> alias:          pci:v00008086d00000082sv*sd00001328bc*sc*i*
> alias:          pci:v00008086d00000082sv*sd00001326bc*sc*i*
> alias:          pci:v00008086d00000082sv*sd00001321bc*sc*i*
> alias:          pci:v00008086d00000082sv*sd00001308bc*sc*i*
> alias:          pci:v00008086d00000082sv*sd00001307bc*sc*i*
> alias:          pci:v00008086d00000082sv*sd00001306bc*sc*i*
> alias:          pci:v00008086d00000082sv*sd00001301bc*sc*i*
> alias:          pci:v00008086d00004239sv*sd00001316bc*sc*i*
> alias:          pci:v00008086d00004239sv*sd00001311bc*sc*i*
> alias:          pci:v00008086d00004238sv*sd00001118bc*sc*i*
> alias:          pci:v00008086d00004238sv*sd00001111bc*sc*i*
> alias:          pci:v00008086d0000422Csv*sd00001326bc*sc*i*
> alias:          pci:v00008086d0000422Csv*sd00001321bc*sc*i*
> alias:          pci:v00008086d0000422Csv*sd00001307bc*sc*i*
> alias:          pci:v00008086d0000422Csv*sd00001306bc*sc*i*
> alias:          pci:v00008086d0000422Csv*sd00001301bc*sc*i*
> alias:          pci:v00008086d0000422Bsv*sd00001128bc*sc*i*
> alias:          pci:v00008086d0000422Bsv*sd00001121bc*sc*i*
> alias:          pci:v00008086d0000422Bsv*sd00001108bc*sc*i*
> alias:          pci:v00008086d0000422Bsv*sd00001101bc*sc*i*
> alias:          pci:v00008086d0000423Dsv*sd00001316bc*sc*i*
> alias:          pci:v00008086d0000423Dsv*sd00001216bc*sc*i*
> alias:          pci:v00008086d0000423Dsv*sd00001311bc*sc*i*
> alias:          pci:v00008086d0000423Dsv*sd00001211bc*sc*i*
> alias:          pci:v00008086d0000423Csv*sd00001326bc*sc*i*
> alias:          pci:v00008086d0000423Csv*sd00001321bc*sc*i*
> alias:          pci:v00008086d0000423Csv*sd00001221bc*sc*i*
> alias:          pci:v00008086d0000423Csv*sd00001306bc*sc*i*
> alias:          pci:v00008086d0000423Csv*sd00001206bc*sc*i*
> alias:          pci:v00008086d0000423Csv*sd00001301bc*sc*i*
> alias:          pci:v00008086d0000423Csv*sd00001201bc*sc*i*
> alias:          pci:v00008086d0000423Bsv*sd00001011bc*sc*i*
> alias:          pci:v00008086d0000423Asv*sd00001021bc*sc*i*
> alias:          pci:v00008086d0000423Asv*sd00001001bc*sc*i*
> alias:          pci:v00008086d00004236sv*sd00001114bc*sc*i*
> alias:          pci:v00008086d00004236sv*sd00001014bc*sc*i*
> alias:          pci:v00008086d00004236sv*sd00001111bc*sc*i*
> alias:          pci:v00008086d00004236sv*sd00001011bc*sc*i*
> alias:          pci:v00008086d00004235sv*sd00001104bc*sc*i*
> alias:          pci:v00008086d00004235sv*sd00001004bc*sc*i*
> alias:          pci:v00008086d00004235sv*sd00001101bc*sc*i*
> alias:          pci:v00008086d00004235sv*sd00001001bc*sc*i*
> alias:          pci:v00008086d00004235sv*sd00001124bc*sc*i*
> alias:          pci:v00008086d00004235sv*sd00001024bc*sc*i*
> alias:          pci:v00008086d00004235sv*sd00001121bc*sc*i*
> alias:          pci:v00008086d00004235sv*sd00001021bc*sc*i*
> alias:          pci:v00008086d00004237sv*sd00001316bc*sc*i*
> alias:          pci:v00008086d00004237sv*sd00001216bc*sc*i*
> alias:          pci:v00008086d00004237sv*sd00001315bc*sc*i*
> alias:          pci:v00008086d00004237sv*sd00001215bc*sc*i*
> alias:          pci:v00008086d00004237sv*sd00001314bc*sc*i*
> alias:          pci:v00008086d00004237sv*sd00001214bc*sc*i*
> alias:          pci:v00008086d00004237sv*sd00001311bc*sc*i*
> alias:          pci:v00008086d00004237sv*sd00001211bc*sc*i*
> alias:          pci:v00008086d00004232sv*sd00001326bc*sc*i*
> alias:          pci:v00008086d00004232sv*sd00001226bc*sc*i*
> alias:          pci:v00008086d00004232sv*sd00001325bc*sc*i*
> alias:          pci:v00008086d00004232sv*sd00001225bc*sc*i*
> alias:          pci:v00008086d00004232sv*sd00001324bc*sc*i*
> alias:          pci:v00008086d00004232sv*sd00001224bc*sc*i*
> alias:          pci:v00008086d00004232sv*sd00001321bc*sc*i*
> alias:          pci:v00008086d00004232sv*sd00001221bc*sc*i*
> alias:          pci:v00008086d00004232sv*sd00001306bc*sc*i*
> alias:          pci:v00008086d00004232sv*sd00001206bc*sc*i*
> alias:          pci:v00008086d00004232sv*sd00001305bc*sc*i*
> alias:          pci:v00008086d00004232sv*sd00001205bc*sc*i*
> alias:          pci:v00008086d00004232sv*sd00001304bc*sc*i*
> alias:          pci:v00008086d00004232sv*sd00001204bc*sc*i*
> alias:          pci:v00008086d00004232sv*sd00001301bc*sc*i*
> alias:          pci:v00008086d00004232sv*sd00001201bc*sc*i*
> depends:        cfg80211
> intree:         Y
> vermagic:       4.8.0-59-generic SMP mod_unload modversions
> parm:           swcrypto:using crypto in software (default 0 [hardware]) (int)
> parm:           11n_disable:disable 11n functionality, bitmap: 1: full, 2: disable agg TX, 4: disable agg RX, 8 enable agg TX (uint)
> parm:           amsdu_size:amsdu size 0: 12K for multi Rx queue devices, 4K for other devices 1:4K 2:8K 3:12K (default 0) (int)
> parm:           fw_restart:restart firmware in case of error (default true) (bool)
> parm:           antenna_coupling:specify antenna coupling in dB (default: 0 dB) (int)
> parm:           nvm_file:NVM file name (charp)
> parm:           d0i3_disable:disable d0i3 functionality (default: Y) (bool)
> parm:           lar_disable:disable LAR functionality (default: N) (bool)
> parm:           uapsd_disable:disable U-APSD functionality bitmap 1: BSS 2: P2P Client (default: 3) (uint)
> parm:           bt_coex_active:enable wifi/bt co-exist (default: enable) (bool)
> parm:           led_mode:0=system default, 1=On(RF On)/Off(RF Off), 2=blinking, 3=Off (default: 0) (int)
> parm:           power_save:enable WiFi power management (default: disable) (bool)
> parm:           power_level:default power save level (range from 1 - 5, default: 1) (int)
> parm:           fw_monitor:firmware monitor - to debug FW (default: false - needs lots of memory) (bool)
> parm:           d0i3_timeout:Timeout to D0i3 entry when idle (ms) (uint)
> parm:           disable_11ac:Disable VHT capabilities (default: false) (bool)
>
