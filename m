Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aldebaran.gro-tsen.net ([88.191.60.176]:38352 "EHLO
	aldebaran.gro-tsen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab2CWRrM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 13:47:12 -0400
Date: Fri, 23 Mar 2012 18:47:08 +0100
From: David Madore <david+ml@madore.org>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath9k_htc fails with "Target is unresponsive"
Message-ID: <20120323174708.GA2797@aldebaran.gro-tsen.net> (sfid-20120323_184718_118165_D26DBDC1)
References: <20120321175800.GA28516@aldebaran.gro-tsen.net>
 <CAJ-Vmom2fPUuuT8mUa2fWrbBQGuDtd7nh7Tkn3Sa2_TmhjtJaA@mail.gmail.com>
 <20120321220242.GA26363@aldebaran.gro-tsen.net>
 <20120322002955.GA9391@aldebaran.gro-tsen.net>
 <20331.61854.29639.644902@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20331.61854.29639.644902@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 23, 2012 at 09:14:30AM +0530, Sujith Manoharan wrote:
> David Madore wrote:
> > More accurately: the dongle fails to work if and only if, since it was
> > last plugged in, there has been a reboot (=anything short of a full
> > power cycle) after it has been initialized by ath9k_htc.

OK, now I've discovered it's a bit more complicated than that: what
causes the dongle to fail is the following combination of events:

* the ath9k_htc module is inserted,

* the wlan0 device is NOT brought up,

* system reboot.

If, however, wlan0 is brought up before reboot, then the dongle is
still fine after reboot.

In other words: loading the module seems to place the dongle in a bad
state that goes away after ifconfig up (but not by removing the
modules), and if a reboot happens while the dongle is in that bad
state, it will fail permanently.

So following your suggestion

> Can you compile the driver/kernel with debugging enabled [1] ?
> Then, load the driver with the module parameter 'debug=0x8701' and post the
> kernel log here (a full run - load, use, reboot, load). Thanks.

I produced a kernel log for the following sequence of events (the
numbers refer to the line numbers in the following log):

* plug in dongle (1-3), insert modules (4-78), bring wlan0 interface
  up (79-113), bring wlan0 interface down (114-127), remove modules
  (128-131), reboot (132-312; the dongle still works),

* insert modules again (313-386), now remove modules without ever
  using the interface (387-391), reboot (392-573),

* insert modules a third time, now they fail (574-580).

The lines marked "[U]" in the log are comments describing what I'm
doing (printed using /dev/ttyprintk):

1	[   80.660385] [U] will insert USB Wifi dongle
2	[   85.789728] usb 1-1.3: new high-speed USB device number 5 using orion-ehci
3	[   91.133286] [U] USB Wifi dongle inserted
4	[   93.974779] [U] will modprobe ath9k_htc debug=0x8701
5	[   95.537593] cfg80211: Calling CRDA to update world regulatory domain
6	[   96.039833] usb 1-1.3: ath9k_htc: Transferred FW: htc_9271.fw, size: 51272
7	[   96.274828] ath9k_htc 1-1.3:1.0: ath9k_htc: HTC initialized with 33 credits
8	[   96.286465] ath: UNDEFINED -> AWAKE
9	[   96.290957] ath: serialize_regmode is 0
10	[   96.430340] ath: Eeprom VER: 14, REV: 13
11	[   96.486965] ath: TX streams 1, RX streams: 1
12	[   96.491456] ath9k_htc 1-1.3:1.0: ath9k_htc: FW Version: 1.3
13	[   96.497555] ath: EEPROM regdomain: 0x809c
14	[   96.501580] ath: EEPROM indicates we should expect a country code
15	[   96.508108] ath: doing EEPROM country->regdmn map search
16	[   96.513448] ath: country maps to regdmn code: 0x52
17	[   96.518621] ath: Country alpha2 being used: CN
18	[   96.523084] ath: Regpair used: 0x52
19	[   96.526945] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
20	[   96.537588] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
21	[   96.545425] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
22	[   96.556067] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
23	[   96.563582] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
24	[   96.574370] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
25	[   96.581886] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
26	[   96.592596] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
27	[   96.600527] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
28	[   96.611267] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
29	[   96.619118] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
30	[   96.629760] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
31	[   96.637594] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
32	[   96.648234] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
33	[   96.656132] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
34	[   96.666781] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
35	[   96.674621] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
36	[   96.685259] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
37	[   96.692777] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
38	[   96.703471] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
39	[   96.711388] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
40	[   96.722035] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
41	[   96.729869] cfg80211: Disabling freq 2467 MHz as custom regd has no rule that fits a 20 MHz wide channel
42	[   96.739720] cfg80211: Disabling freq 2472 MHz as custom regd has no rule that fits a 20 MHz wide channel
43	[   96.749623] cfg80211: Disabling freq 2484 MHz as custom regd has no rule that fits a 20 MHz wide channel
44	[   96.760788] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
45	[   96.771608] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
46	[   96.779480] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
47	[   96.790127] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
48	[   96.797968] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
49	[   96.808691] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
50	[   96.816533] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
51	[   96.827176] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
52	[   96.835018] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
53	[   96.845665] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
54	[   96.853183] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
55	[   96.863897] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
56	[   96.871417] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
57	[   96.882110] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
58	[   96.889955] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
59	[   96.900601] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
60	[   96.908514] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
61	[   96.919157] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
62	[   96.926995] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
63	[   96.937683] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
64	[   96.945529] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
65	[   96.956173] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
66	[   96.964012] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
67	[   96.974649] cfg80211: 2457000 KHz - 2482000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
68	[   96.982168] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
69	[   96.992863] cfg80211: 2457000 KHz - 2482000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
70	[   97.000790] cfg80211: Updating information on frequency 2484 MHz for a 20 MHz width channel with regulatory rule:
71	[   97.011523] cfg80211: 2474000 KHz - 2494000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
72	[   97.030427] cfg80211: Pending regulatory request, waiting for it to be processed...
73	[   97.038765] ath: WMI:1, BCN:2, CAB:3, UAPSD:4, MGMT:5, BE:6, BK:7, VI:8, VO:9
74	[   97.046317] ieee80211 phy0: Atheros AR9271 Rev:1
75	[   97.053151] Registered led device: ath9k_htc-phy0
76	[   97.058389] usb 1-1.3: ath9k_htc: USB layer initialized
77	[   97.073670] usbcore: registered new interface driver ath9k_htc
78	[   97.790181] [U] did modprobe ath9k_htc debug=0x8701
79	[  104.033706] [U] will ifconfig wlan0 up
80	[  105.816834] ath: Starting driver with initial channel: 2412 MHz
81	[  105.846840] ath: ah->misc_mode 0x4
82	[  105.874961] ath: Added a station entry for VIF 0 (idx: 0)
83	[  105.881464] ath: Attach a VIF of type: 2 at idx: 0
84	[  105.886287] ath: ah->misc_mode 0x4
85	[  105.891743] ath: Set channel: 2412 MHz
86	[  105.895959] ath: (2412 MHz) -> (2412 MHz), HT: 0, HT40: 0 fastcc: 0
87	[  105.925839] ath: ah->misc_mode 0x4
88	[  105.951592] ath: AWAKE -> FULL-SLEEP
89	[  105.955833] ath: FULL-SLEEP -> AWAKE
90	[  105.961962] ath: idle: disabling radio
91	[  105.990458] ath: ah->misc_mode 0x4
92	[  106.014464] ath: AWAKE -> FULL-SLEEP
93	[  106.018712] ath: FULL-SLEEP -> AWAKE
94	[  106.023469] ath: Configure tx [queue/hwq] [0/3],  aifs: 2, cw_min: 7, cw_max: 15, txop: 102
95	[  106.032464] ath: AWAKE -> FULL-SLEEP
96	[  106.036708] ath: FULL-SLEEP -> AWAKE
97	[  106.041462] ath: Configure tx [queue/hwq] [1/2],  aifs: 2, cw_min: 15, cw_max: 31, txop: 188
98	[  106.050589] ath: AWAKE -> FULL-SLEEP
99	[  106.054832] ath: FULL-SLEEP -> AWAKE
100	[  106.059719] ath: Configure tx [queue/hwq] [2/0],  aifs: 3, cw_min: 31, cw_max: 1023, txop: 0
101	[  106.068456] ath: AWAKE -> FULL-SLEEP
102	[  106.073089] ath: FULL-SLEEP -> AWAKE
103	[  106.077460] ath: Configure tx [queue/hwq] [3/1],  aifs: 7, cw_min: 31, cw_max: 1023, txop: 0
104	[  106.086589] ath: AWAKE -> FULL-SLEEP
105	[  106.091084] ath: FULL-SLEEP -> AWAKE
106	[  106.095457] ath: AWAKE -> FULL-SLEEP
107	[  106.100110] ath: FULL-SLEEP -> AWAKE
108	[  106.103988] ADDRCONF(NETDEV_UP): wlan0: link is not ready
109	[  106.111342] ath: Set HW RX filter: 0x207
110	[  106.115288] ath: AWAKE -> FULL-SLEEP
111	[  106.122343] ath: FULL-SLEEP -> AWAKE
112	[  106.127207] ath: Set HW RX filter: 0x207
113	[  106.131667] ath: AWAKE -> FULL-SLEEP
114	[  113.572691] [U] will ifconfig wlan0 down
115	[  115.192989] ath: FULL-SLEEP -> AWAKE
116	[  115.198584] ath: Set HW RX filter: 0x207
117	[  115.202530] ath: AWAKE -> FULL-SLEEP
118	[  115.207235] ath: FULL-SLEEP -> AWAKE
119	[  115.212081] ath: Set HW RX filter: 0x207
120	[  115.216404] ath: AWAKE -> FULL-SLEEP
121	[  115.220589] ath: FULL-SLEEP -> AWAKE
122	[  115.225839] ath: Removed a station entry for VIF 0 (idx: 0)
123	[  115.232206] ath: Detach Interface at idx: 0
124	[  115.236803] ath: AWAKE -> FULL-SLEEP
125	[  115.241342] ath: FULL-SLEEP -> AWAKE
126	[  115.250086] ath: AWAKE -> FULL-SLEEP
127	[  115.254713] ath: Driver halt
128	[  122.235397] [U] will modprobe -r ath9k_htc mac80211 ath9k_common ath9k_hw ath cfg80211
129	[  124.162988] usbcore: deregistering interface driver ath9k_htc
130	[  124.192845] usb 1-1.3: ath9k_htc: USB layer deinitialized
131	[  124.198321] ath9k_htc: Driver unloaded
132	[  128.788157] [U] *** will now reboot ***
133	[  149.935801] Restarting system.
134	[    0.000000] Initializing cgroup subsys cpu
135	[    0.000000] Linux version 3.2.12-dreamplug (david@vega.stars) (gcc version 4.6.3 (GCC) ) #1 PREEMPT Fri Mar 23 12:38:15 CET 2012
136	[    0.000000] CPU: Feroceon 88FR131 [56251311] revision 1 (ARMv5TE), cr=00053977
137	[    0.000000] CPU: VIVT data cache, VIVT instruction cache
138	[    0.000000] Machine: Marvell DreamPlug Reference Board
139	[    0.000000] Memory policy: ECC disabled, Data cache writeback
140	[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 130048
141	[    0.000000] Kernel command line: console=ttyS0,115200 root=/dev/sda2 rootdelay=10 ro
142	[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
143	[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
144	[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
145	[    0.000000] Memory: 512MB = 512MB total
146	[    0.000000] Memory: 513120k/513120k available, 11168k reserved, 0K highmem
147	[    0.000000] Virtual kernel memory layout:
148	[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
149	[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
150	[    0.000000]     vmalloc : 0xe0800000 - 0xfe800000   ( 480 MB)
151	[    0.000000]     lowmem  : 0xc0000000 - 0xe0000000   ( 512 MB)
152	[    0.000000]     modules : 0xbf000000 - 0xc0000000   (  16 MB)
153	[    0.000000]       .text : 0xc0008000 - 0xc0581760   (5606 kB)
154	[    0.000000]       .init : 0xc0582000 - 0xc05ac000   ( 168 kB)
155	[    0.000000]       .data : 0xc05ac000 - 0xc05ef4b8   ( 270 kB)
156	[    0.000000]        .bss : 0xc05ef4dc - 0xc067afc0   ( 559 kB)
157	[    0.000000] SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
158	[    0.000000] NR_IRQS:114
159	[    0.000000] sched_clock: 32 bits at 200MHz, resolution 5ns, wraps every 21474ms
160	[    0.000000] Console: colour dummy device 80x30
161	[    7.664419] Calibrating delay loop... 1191.11 BogoMIPS (lpj=5955584)
162	[    7.754354] pid_max: default: 32768 minimum: 301
163	[    7.754443] Security Framework initialized
164	[    7.754461] SELinux:  Disabled at boot.
165	[    7.754507] Mount-cache hash table entries: 512
166	[    7.754801] Initializing cgroup subsys debug
167	[    7.754814] Initializing cgroup subsys cpuacct
168	[    7.754829] Initializing cgroup subsys devices
169	[    7.754838] Initializing cgroup subsys freezer
170	[    7.754883] CPU: Testing write buffer coherency: ok
171	[    7.755754] devtmpfs: initialized
172	[    7.757168] NET: Registered protocol family 16
173	[    7.759362] Kirkwood: MV88F6281-A1, TCLK=200000000.
174	[    7.759376] Feroceon L2: Cache support initialised.
175	[    7.776533] bio: create slab <bio-0> at 0
176	[    7.777243] vgaarb: loaded
177	[    7.777885] SCSI subsystem initialized
178	[    7.779148] usbcore: registered new interface driver usbfs
179	[    7.779467] usbcore: registered new interface driver hub
180	[    7.779681] usbcore: registered new device driver usb
181	[    7.781278] NET: Registered protocol family 8
182	[    7.781289] NET: Registered protocol family 20
183	[    7.781853] Switching to clocksource orion_clocksource
184	[    7.813663] NET: Registered protocol family 2
185	[    7.813871] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
186	[    7.814499] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
187	[    7.814854] TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
188	[    7.815033] TCP: Hash tables configured (established 16384 bind 16384)
189	[    7.815042] TCP reno registered
190	[    7.815052] UDP hash table entries: 256 (order: 0, 4096 bytes)
191	[    7.815074] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
192	[    7.815281] NET: Registered protocol family 1
193	[    7.816559] audit: initializing netlink socket (disabled)
194	[    7.816594] type=2000 audit(0.140:1): initialized
195	[    7.905836] VFS: Disk quotas dquot_6.5.2
196	[    7.906202] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
197	[    7.910073] JFFS2 version 2.2. (NAND) © 2001-2006 Red Hat, Inc.
198	[    7.911057] msgmni has been set to 1002
199	[    7.914087] alg: No test for stdrng (krng)
200	[    7.914332] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
201	[    7.914346] io scheduler noop registered
202	[    7.914354] io scheduler deadline registered (default)
203	[    7.914437] mv_xor_shared mv_xor_shared.0: Marvell shared XOR driver
204	[    7.914471] mv_xor_shared mv_xor_shared.1: Marvell shared XOR driver
205	[    7.951926] mv_xor mv_xor.0: Marvell XOR: ( xor cpy )
206	[    7.991935] mv_xor mv_xor.1: Marvell XOR: ( xor fill cpy )
207	[    8.031926] mv_xor mv_xor.2: Marvell XOR: ( xor cpy )
208	[    8.071924] mv_xor mv_xor.3: Marvell XOR: ( xor fill cpy )
209	[    8.080495] Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
210	[    8.102048] serial8250.0: ttyS0 at MMIO 0xf1012000 (irq = 33) is a 16550A
211	[    8.519000] console [ttyS0] enabled
212	[    8.525874] m25p80 spi0.0: mx25l1606e (2048 Kbytes)
213	[    8.530981] Creating 2 MTD partitions on "spi_flash":
214	[    8.536232] 0x000000000000-0x000000080000 : "u-boot"
215	[    8.542563] 0x000000100000-0x000000110000 : "u-boot env"
216	[    8.550637] mv643xx_eth: MV-643xx 10/100/1000 ethernet driver version 1.4
217	[    8.557817] mv643xx_eth smi: probed
218	[    8.564904] mv643xx_eth_port mv643xx_eth_port.0: eth0: port 0 with MAC address f0:ad:4e:00:df:b1
219	[    8.577107] mv643xx_eth_port mv643xx_eth_port.1: eth1: port 0 with MAC address f0:ad:4e:00:df:b2
220	[    8.586154] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
221	[    8.592815] orion-ehci orion-ehci.0: Marvell Orion EHCI
222	[    8.598121] orion-ehci orion-ehci.0: new USB bus registered, assigned bus number 1
223	[    8.631902] orion-ehci orion-ehci.0: irq 19, io mem 0xf1050000
224	[    8.651896] orion-ehci orion-ehci.0: USB 2.0 started, EHCI 1.00
225	[    8.658610] hub 1-0:1.0: USB hub found
226	[    8.662455] hub 1-0:1.0: 1 port detected
227	[    8.667199] Initializing USB Mass Storage driver...
228	[    8.672384] usbcore: registered new interface driver usb-storage
229	[    8.678419] USB Mass Storage support registered.
230	[    8.683258] usbcore: registered new interface driver ums-datafab
231	[    8.689469] usbcore: registered new interface driver ums-freecom
232	[    8.695681] usbcore: registered new interface driver ums-jumpshot
233	[    8.702002] usbcore: registered new interface driver ums-sddr09
234	[    8.708086] usbcore: registered new interface driver ums-sddr55
235	[    8.714606] mousedev: PS/2 mouse device common for all mice
236	[    8.720802] rtc-mv rtc-mv: rtc core: registered rtc-mv as rtc0
237	[    8.727071] i2c /dev entries driver
238	[    8.731206] cpuidle: using governor ladder
239	[    8.735960] cpuidle: using governor menu
240	[    8.740206] sdhci: Secure Digital Host Controller Interface driver
241	[    8.746515] sdhci: Copyright(c) Pierre Ossman
242	[    8.752223] mmc0: mvsdio driver initialized, lacking card detect (fall back to polling)
243	[    8.760510] sdhci-pltfm: SDHCI platform and OF driver helper
244	[    8.768014] MV-CESA:Fallback driver 'sha1' could not be loaded!
245	[    8.774064] alg: hash: Failed to load transform for mv-sha1: -2
246	[    8.780534] MV-CESA:Fallback driver 'hmac(sha1)' could not be loaded!
247	[    8.787075] alg: hash: Failed to load transform for mv-hmac-sha1: -2
248	[    8.795244] usbcore: registered new interface driver usbhid
249	[    8.802928] usbhid: USB HID core driver
250	[    8.806798] oprofile: hardware counters not available
251	[    8.811915] oprofile: using timer interrupt.
252	[    8.817186] TCP cubic registered
253	[    8.820449] NET: Registered protocol family 17
254	[    8.825196] lib80211: common routines for IEEE802.11 drivers
255	[    8.831844] registered taskstats version 1
256	[    8.836306] rtc-mv rtc-mv: setting system clock to 2012-03-23 17:07:29 UTC (1332522449)
257	[    8.844669] Waiting 10sec before mounting root device...
258	[    8.866689] mmc0: new high speed SDIO card at address 0001
259	[    8.981907] usb 1-1: new high-speed USB device number 2 using orion-ehci
260	[    9.133200] hub 1-1:1.0: USB hub found
261	[    9.137094] hub 1-1:1.0: 4 ports detected
262	[    9.411971] usb 1-1.1: new high-speed USB device number 3 using orion-ehci
263	[    9.524917] scsi0 : usb-storage 1-1.1:1.0
264	[    9.601996] usb 1-1.3: new high-speed USB device number 4 using orion-ehci
265	[    9.811996] usb 1-1.4: new full-speed USB device number 5 using orion-ehci
266	[    9.926810] input: C-Media USB Headphone Set   as /devices/platform/orion-ehci.0/usb1/1-1/1-1.4/1-1.4:1.3/input/input0
267	[    9.937978] generic-usb 0003:0D8C:000C.0001: input: USB HID v1.00 Device [C-Media USB Headphone Set  ] on usb-orion-ehci.0-1.4/input3
268	[   10.543188] scsi 0:0:0:0: Direct-Access     Generic  STORAGE DEVICE   9910 PQ: 0 ANSI: 0
269	[   10.553553] scsi 0:0:0:1: Direct-Access     Generic  STORAGE DEVICE   9910 PQ: 0 ANSI: 0
270	[   10.562389] sd 0:0:0:0: [sda] 7744512 512-byte logical blocks: (3.96 GB/3.69 GiB)
271	[   10.571033] sd 0:0:0:0: [sda] Write Protect is off
272	[   10.577642] sd 0:0:0:0: [sda] No Caching mode page present
273	[   10.583485] sd 0:0:0:0: [sda] Assuming drive cache: write through
274	[   10.590880] sd 0:0:0:1: [sdb] Attached SCSI removable disk
275	[   10.600116] sd 0:0:0:0: [sda] No Caching mode page present
276	[   10.605671] sd 0:0:0:0: [sda] Assuming drive cache: write through
277	[   10.623685]  sda: sda1 sda2
278	[   10.629865] sd 0:0:0:0: [sda] No Caching mode page present
279	[   10.635431] sd 0:0:0:0: [sda] Assuming drive cache: write through
280	[   10.641556] sd 0:0:0:0: [sda] Attached SCSI removable disk
281	[   18.867970] EXT3-fs (sda2): mounted filesystem with ordered data mode
282	[   18.874504] kjournald starting.  Commit interval 5 seconds
283	[   18.880043] VFS: Mounted root (ext3 filesystem) readonly on device 8:2.
284	[   18.890275] devtmpfs: mounted
285	[   18.893780] Freeing init memory: 168K
286	[   20.308768] udev[608]: starting version 164
287	[   20.887441] scsi1 : sata_mv
288	[   20.890509] ata1: SATA max UDMA/133 irq 21
289	[   21.152213] Bluetooth: Core ver 2.16
290	[   21.155861] NET: Registered protocol family 31
291	[   21.160328] Bluetooth: HCI device and connection manager initialized
292	[   21.288872] Bluetooth: HCI socket layer initialized
293	[   21.354922] Bluetooth: L2CAP socket layer initialized
294	[   21.360024] Bluetooth: SCO socket layer initialized
295	[   21.382088] ata1: SATA link down (SStatus 0 SControl F300)
296	[   21.459507] Bluetooth: vendor=0x2df, device=0x911a, class=255, fn=2
297	[   21.497935] Bluetooth: sbi_interrupt(dfa33e00) card or priv is NULL, card=dfbcdb40
298	[   21.497944] 
299	[   21.747018] usbcore: registered new interface driver snd-usb-audio
300	[   51.456643] EXT3-fs (sda2): using internal journal
301	[   53.305677] NET: Registered protocol family 10
302	[   53.328970] Orion Watchdog Timer: Initial timeout 21 sec
303	[   54.500294] ADDRCONF(NETDEV_UP): eth0: link is not ready
304	[   57.809848] mv643xx_eth_port mv643xx_eth_port.0: eth0: link up, 1000 Mb/s, full duplex, flow control disabled
305	[   57.819983] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
306	[   59.500777] ADDRCONF(NETDEV_UP): eth1: link is not ready
307	[   62.568490] wd_keepalive (1597): /proc/1597/oom_adj is deprecated, please use /proc/1597/oom_score_adj instead.
308	[   71.073810] Bluetooth: RFCOMM socket layer initialized
309	[   71.079068] Bluetooth: RFCOMM ver 1.11
310	[   71.165131] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
311	[   71.220746] Bridge firewalling registered
312	[   93.632341] [U] *** after reboot ***
313	[   97.207998] [U] will again modprobe ath9k_htc debug=0x8701
314	[   98.895845] cfg80211: Calling CRDA to update world regulatory domain
315	[   99.384114] usb 1-1.3: ath9k_htc: Transferred FW: htc_9271.fw, size: 51272
316	[   99.619222] ath9k_htc 1-1.3:1.0: ath9k_htc: HTC initialized with 33 credits
317	[   99.631489] ath: UNDEFINED -> AWAKE
318	[   99.636479] ath: serialize_regmode is 0
319	[   99.775251] ath: Eeprom VER: 14, REV: 13
320	[   99.831485] ath: TX streams 1, RX streams: 1
321	[   99.836361] ath9k_htc 1-1.3:1.0: ath9k_htc: FW Version: 1.3
322	[   99.841961] ath: EEPROM regdomain: 0x809c
323	[   99.846389] ath: EEPROM indicates we should expect a country code
324	[   99.852512] ath: doing EEPROM country->regdmn map search
325	[   99.858244] ath: country maps to regdmn code: 0x52
326	[   99.863056] ath: Country alpha2 being used: CN
327	[   99.867874] ath: Regpair used: 0x52
328	[   99.871378] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
329	[   99.882063] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
330	[   99.889897] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
331	[   99.900609] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
332	[   99.908454] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
333	[   99.919095] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
334	[   99.926929] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
335	[   99.937559] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
336	[   99.945076] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
337	[   99.955837] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
338	[   99.963353] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
339	[   99.974041] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
340	[   99.981872] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
341	[   99.992503] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
342	[  100.000332] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
343	[  100.010963] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
344	[  100.018793] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
345	[  100.029424] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
346	[  100.037253] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
347	[  100.047882] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
348	[  100.055790] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
349	[  100.066478] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
350	[  100.073993] cfg80211: Disabling freq 2467 MHz as custom regd has no rule that fits a 20 MHz wide channel
351	[  100.083942] cfg80211: Disabling freq 2472 MHz as custom regd has no rule that fits a 20 MHz wide channel
352	[  100.093786] cfg80211: Disabling freq 2484 MHz as custom regd has no rule that fits a 20 MHz wide channel
353	[  100.104983] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
354	[  100.115734] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
355	[  100.123254] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
356	[  100.133967] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
357	[  100.141806] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
358	[  100.152440] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
359	[  100.160352] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
360	[  100.170986] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
361	[  100.178879] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
362	[  100.189523] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
363	[  100.197356] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
364	[  100.207994] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
365	[  100.215822] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
366	[  100.226452] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
367	[  100.233971] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
368	[  100.244659] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
369	[  100.252491] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
370	[  100.263202] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
371	[  100.271029] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
372	[  100.281660] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
373	[  100.289489] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
374	[  100.300119] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
375	[  100.307947] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
376	[  100.318580] cfg80211: 2457000 KHz - 2482000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
377	[  100.326407] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
378	[  100.337058] cfg80211: 2457000 KHz - 2482000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
379	[  100.344576] cfg80211: Updating information on frequency 2484 MHz for a 20 MHz width channel with regulatory rule:
380	[  100.355402] cfg80211: 2474000 KHz - 2494000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
381	[  100.374425] cfg80211: Pending regulatory request, waiting for it to be processed...
382	[  100.382687] ath: WMI:1, BCN:2, CAB:3, UAPSD:4, MGMT:5, BE:6, BK:7, VI:8, VO:9
383	[  100.390224] ieee80211 phy0: Atheros AR9271 Rev:1
384	[  100.397297] Registered led device: ath9k_htc-phy0
385	[  100.402034] usb 1-1.3: ath9k_htc: USB layer initialized
386	[  100.415090] usbcore: registered new interface driver ath9k_htc
387	[  126.828893] [U] will modprobe -r ath9k_htc mac80211 ath9k_common ath9k_hw ath cfg80211
388	[  128.961519] usbcore: deregistering interface driver ath9k_htc
389	[  128.990372] ath: AWAKE -> FULL-SLEEP
390	[  129.003812] usb 1-1.3: ath9k_htc: USB layer deinitialized
391	[  129.019774] ath9k_htc: Driver unloaded
392	[  170.610990] [U] *** will now reboot again ***
393	[  192.522070] Restarting system.
394	[    0.000000] Initializing cgroup subsys cpu
395	[    0.000000] Linux version 3.2.12-dreamplug (david@vega.stars) (gcc version 4.6.3 (GCC) ) #1 PREEMPT Fri Mar 23 12:38:15 CET 2012
396	[    0.000000] CPU: Feroceon 88FR131 [56251311] revision 1 (ARMv5TE), cr=00053977
397	[    0.000000] CPU: VIVT data cache, VIVT instruction cache
398	[    0.000000] Machine: Marvell DreamPlug Reference Board
399	[    0.000000] Memory policy: ECC disabled, Data cache writeback
400	[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 130048
401	[    0.000000] Kernel command line: console=ttyS0,115200 root=/dev/sda2 rootdelay=10 ro
402	[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
403	[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
404	[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
405	[    0.000000] Memory: 512MB = 512MB total
406	[    0.000000] Memory: 513120k/513120k available, 11168k reserved, 0K highmem
407	[    0.000000] Virtual kernel memory layout:
408	[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
409	[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
410	[    0.000000]     vmalloc : 0xe0800000 - 0xfe800000   ( 480 MB)
411	[    0.000000]     lowmem  : 0xc0000000 - 0xe0000000   ( 512 MB)
412	[    0.000000]     modules : 0xbf000000 - 0xc0000000   (  16 MB)
413	[    0.000000]       .text : 0xc0008000 - 0xc0581760   (5606 kB)
414	[    0.000000]       .init : 0xc0582000 - 0xc05ac000   ( 168 kB)
415	[    0.000000]       .data : 0xc05ac000 - 0xc05ef4b8   ( 270 kB)
416	[    0.000000]        .bss : 0xc05ef4dc - 0xc067afc0   ( 559 kB)
417	[    0.000000] SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
418	[    0.000000] NR_IRQS:114
419	[    0.000000] sched_clock: 32 bits at 200MHz, resolution 5ns, wraps every 21474ms
420	[    0.000000] Console: colour dummy device 80x30
421	[   10.275058] Calibrating delay loop... 1191.11 BogoMIPS (lpj=5955584)
422	[   10.364993] pid_max: default: 32768 minimum: 301
423	[   10.365082] Security Framework initialized
424	[   10.365100] SELinux:  Disabled at boot.
425	[   10.365145] Mount-cache hash table entries: 512
426	[   10.365438] Initializing cgroup subsys debug
427	[   10.365451] Initializing cgroup subsys cpuacct
428	[   10.365466] Initializing cgroup subsys devices
429	[   10.365474] Initializing cgroup subsys freezer
430	[   10.365520] CPU: Testing write buffer coherency: ok
431	[   10.366387] devtmpfs: initialized
432	[   10.367801] NET: Registered protocol family 16
433	[   10.369986] Kirkwood: MV88F6281-A1, TCLK=200000000.
434	[   10.370001] Feroceon L2: Cache support initialised.
435	[   10.387124] bio: create slab <bio-0> at 0
436	[   10.387834] vgaarb: loaded
437	[   10.388475] SCSI subsystem initialized
438	[   10.389735] usbcore: registered new interface driver usbfs
439	[   10.390051] usbcore: registered new interface driver hub
440	[   10.390266] usbcore: registered new device driver usb
441	[   10.391857] NET: Registered protocol family 8
442	[   10.391868] NET: Registered protocol family 20
443	[   10.392427] Switching to clocksource orion_clocksource
444	[   10.424248] NET: Registered protocol family 2
445	[   10.424456] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
446	[   10.425084] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
447	[   10.425438] TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
448	[   10.425617] TCP: Hash tables configured (established 16384 bind 16384)
449	[   10.425626] TCP reno registered
450	[   10.425637] UDP hash table entries: 256 (order: 0, 4096 bytes)
451	[   10.425658] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
452	[   10.425866] NET: Registered protocol family 1
453	[   10.427132] audit: initializing netlink socket (disabled)
454	[   10.427166] type=2000 audit(0.140:1): initialized
455	[   10.516357] VFS: Disk quotas dquot_6.5.2
456	[   10.516724] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
457	[   10.520594] JFFS2 version 2.2. (NAND) © 2001-2006 Red Hat, Inc.
458	[   10.521576] msgmni has been set to 1002
459	[   10.524633] alg: No test for stdrng (krng)
460	[   10.524882] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
461	[   10.524897] io scheduler noop registered
462	[   10.524905] io scheduler deadline registered (default)
463	[   10.524987] mv_xor_shared mv_xor_shared.0: Marvell shared XOR driver
464	[   10.525020] mv_xor_shared mv_xor_shared.1: Marvell shared XOR driver
465	[   10.562500] mv_xor mv_xor.0: Marvell XOR: ( xor cpy )
466	[   10.602510] mv_xor mv_xor.1: Marvell XOR: ( xor fill cpy )
467	[   10.642498] mv_xor mv_xor.2: Marvell XOR: ( xor cpy )
468	[   10.682499] mv_xor mv_xor.3: Marvell XOR: ( xor fill cpy )
469	[   10.691058] Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
470	[   10.712613] serial8250.0: ttyS0 at MMIO 0xf1012000 (irq = 33) is a 16550A
471	[   11.129572] console [ttyS0] enabled
472	[   11.136444] m25p80 spi0.0: mx25l1606e (2048 Kbytes)
473	[   11.141551] Creating 2 MTD partitions on "spi_flash":
474	[   11.146801] 0x000000000000-0x000000080000 : "u-boot"
475	[   11.153136] 0x000000100000-0x000000110000 : "u-boot env"
476	[   11.161204] mv643xx_eth: MV-643xx 10/100/1000 ethernet driver version 1.4
477	[   11.168387] mv643xx_eth smi: probed
478	[   11.175456] mv643xx_eth_port mv643xx_eth_port.0: eth0: port 0 with MAC address f0:ad:4e:00:df:b1
479	[   11.187662] mv643xx_eth_port mv643xx_eth_port.1: eth1: port 0 with MAC address f0:ad:4e:00:df:b2
480	[   11.196707] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
481	[   11.203366] orion-ehci orion-ehci.0: Marvell Orion EHCI
482	[   11.208675] orion-ehci orion-ehci.0: new USB bus registered, assigned bus number 1
483	[   11.242475] orion-ehci orion-ehci.0: irq 19, io mem 0xf1050000
484	[   11.262471] orion-ehci orion-ehci.0: USB 2.0 started, EHCI 1.00
485	[   11.269194] hub 1-0:1.0: USB hub found
486	[   11.273043] hub 1-0:1.0: 1 port detected
487	[   11.277785] Initializing USB Mass Storage driver...
488	[   11.282973] usbcore: registered new interface driver usb-storage
489	[   11.289008] USB Mass Storage support registered.
490	[   11.293854] usbcore: registered new interface driver ums-datafab
491	[   11.300066] usbcore: registered new interface driver ums-freecom
492	[   11.306278] usbcore: registered new interface driver ums-jumpshot
493	[   11.312588] usbcore: registered new interface driver ums-sddr09
494	[   11.318713] usbcore: registered new interface driver ums-sddr55
495	[   11.325203] mousedev: PS/2 mouse device common for all mice
496	[   11.331396] rtc-mv rtc-mv: rtc core: registered rtc-mv as rtc0
497	[   11.337669] i2c /dev entries driver
498	[   11.341809] cpuidle: using governor ladder
499	[   11.346563] cpuidle: using governor menu
500	[   11.350811] sdhci: Secure Digital Host Controller Interface driver
501	[   11.357119] sdhci: Copyright(c) Pierre Ossman
502	[   11.362829] mmc0: mvsdio driver initialized, lacking card detect (fall back to polling)
503	[   11.371117] sdhci-pltfm: SDHCI platform and OF driver helper
504	[   11.378609] MV-CESA:Fallback driver 'sha1' could not be loaded!
505	[   11.384660] alg: hash: Failed to load transform for mv-sha1: -2
506	[   11.391131] MV-CESA:Fallback driver 'hmac(sha1)' could not be loaded!
507	[   11.397671] alg: hash: Failed to load transform for mv-hmac-sha1: -2
508	[   11.405830] usbcore: registered new interface driver usbhid
509	[   11.413515] usbhid: USB HID core driver
510	[   11.417386] oprofile: hardware counters not available
511	[   11.422505] oprofile: using timer interrupt.
512	[   11.427778] TCP cubic registered
513	[   11.431046] NET: Registered protocol family 17
514	[   11.435788] lib80211: common routines for IEEE802.11 drivers
515	[   11.442438] registered taskstats version 1
516	[   11.446899] rtc-mv rtc-mv: setting system clock to 2012-03-23 17:10:45 UTC (1332522645)
517	[   11.455261] Waiting 10sec before mounting root device...
518	[   11.477287] mmc0: new high speed SDIO card at address 0001
519	[   11.592482] usb 1-1: new high-speed USB device number 2 using orion-ehci
520	[   11.743849] hub 1-1:1.0: USB hub found
521	[   11.747741] hub 1-1:1.0: 4 ports detected
522	[   12.032625] usb 1-1.1: new high-speed USB device number 3 using orion-ehci
523	[   12.145439] scsi0 : usb-storage 1-1.1:1.0
524	[   12.222644] usb 1-1.3: new high-speed USB device number 4 using orion-ehci
525	[   12.432644] usb 1-1.4: new full-speed USB device number 5 using orion-ehci
526	[   12.547204] input: C-Media USB Headphone Set   as /devices/platform/orion-ehci.0/usb1/1-1/1-1.4/1-1.4:1.3/input/input0
527	[   12.558369] generic-usb 0003:0D8C:000C.0001: input: USB HID v1.00 Device [C-Media USB Headphone Set  ] on usb-orion-ehci.0-1.4/input3
528	[   13.163586] scsi 0:0:0:0: Direct-Access     Generic  STORAGE DEVICE   9910 PQ: 0 ANSI: 0
529	[   13.173941] scsi 0:0:0:1: Direct-Access     Generic  STORAGE DEVICE   9910 PQ: 0 ANSI: 0
530	[   13.183049] sd 0:0:0:0: [sda] 7744512 512-byte logical blocks: (3.96 GB/3.69 GiB)
531	[   13.192294] sd 0:0:0:0: [sda] Write Protect is off
532	[   13.198775] sd 0:0:0:1: [sdb] Attached SCSI removable disk
533	[   13.205160] sd 0:0:0:0: [sda] No Caching mode page present
534	[   13.210701] sd 0:0:0:0: [sda] Assuming drive cache: write through
535	[   13.220514] sd 0:0:0:0: [sda] No Caching mode page present
536	[   13.226069] sd 0:0:0:0: [sda] Assuming drive cache: write through
537	[   13.243829]  sda: sda1 sda2
538	[   13.250014] sd 0:0:0:0: [sda] No Caching mode page present
539	[   13.255575] sd 0:0:0:0: [sda] Assuming drive cache: write through
540	[   13.261693] sd 0:0:0:0: [sda] Attached SCSI removable disk
541	[   21.478368] EXT3-fs (sda2): mounted filesystem with ordered data mode
542	[   21.484900] kjournald starting.  Commit interval 5 seconds
543	[   21.490439] VFS: Mounted root (ext3 filesystem) readonly on device 8:2.
544	[   21.500671] devtmpfs: mounted
545	[   21.504177] Freeing init memory: 168K
546	[   22.914934] udev[607]: starting version 164
547	[   23.325595] sata_mv sata_mv.0: slots 32 ports 1
548	[   23.502536] scsi1 : sata_mv
549	[   23.505611] ata1: SATA max UDMA/133 irq 21
550	[   23.651586] Bluetooth: Core ver 2.16
551	[   23.732636] NET: Registered protocol family 31
552	[   23.782537] Bluetooth: HCI device and connection manager initialized
553	[   23.828536] Bluetooth: HCI socket layer initialized
554	[   23.852537] ata1: SATA link down (SStatus 0 SControl F300)
555	[   23.901255] Bluetooth: L2CAP socket layer initialized
556	[   23.944079] Bluetooth: SCO socket layer initialized
557	[   24.002539] Bluetooth: vendor=0x2df, device=0x911a, class=255, fn=2
558	[   24.046846] Bluetooth: sbi_interrupt(dfa29e00) card or priv is NULL, card=dfa86d40
559	[   24.046853] 
560	[   24.347687] usbcore: registered new interface driver snd-usb-audio
561	[   35.356691] EXT3-fs (sda2): using internal journal
562	[   37.227314] NET: Registered protocol family 10
563	[   37.253379] Orion Watchdog Timer: Initial timeout 21 sec
564	[   38.509883] ADDRCONF(NETDEV_UP): eth0: link is not ready
565	[   41.826179] mv643xx_eth_port mv643xx_eth_port.0: eth0: link up, 1000 Mb/s, full duplex, flow control disabled
566	[   41.836317] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
567	[   45.688099] ADDRCONF(NETDEV_UP): eth1: link is not ready
568	[   48.699732] wd_keepalive (1479): /proc/1479/oom_adj is deprecated, please use /proc/1479/oom_score_adj instead.
569	[   55.876343] Bluetooth: RFCOMM socket layer initialized
570	[   55.881552] Bluetooth: RFCOMM ver 1.11
571	[   55.962084] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
572	[   56.021478] Bridge firewalling registered
573	[  107.414151] [U] *** after second reboot ***
574	[  109.632245] [U] will again modprobe ath9k_htc debug=0x8701
575	[  111.270807] cfg80211: Calling CRDA to update world regulatory domain
576	[  111.772500] usb 1-1.3: ath9k_htc: Transferred FW: htc_9271.fw, size: 51272
577	[  112.770650] ath9k_htc 1-1.3:1.0: ath9k_htc: Target is unresponsive
578	[  112.776869] Failed to initialize the device
579	[  112.783471] ath9k_htc: probe of 1-1.3:1.0 failed with error -22
580	[  112.790391] usbcore: registered new interface driver ath9k_htc
581	[  124.938370] [U] will modprobe -r ath9k_htc mac80211 ath9k_common ath9k_hw ath cfg80211
582	[  128.529827] usbcore: deregistering interface driver ath9k_htc
583	[  128.536854] ath9k_htc: Driver unloaded

-- 
     David A. Madore
   ( http://www.madore.org/~david/ )
