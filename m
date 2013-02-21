Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.watchguard.com ([206.191.171.101]:62361 "EHLO
	watchguard.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753547Ab3BUL0i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 06:26:38 -0500
From: Felix Liao <Felix.Liao@watchguard.com>
To: Felix Fietkau <nbd@openwrt.org>, Adrian Chadd <adrian@freebsd.org>,
	"Sven Eckelmann" <sven@narfation.org>
CC: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"mcgrof@qca.qualcomm.com" <mcgrof@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"lindner_marek@yahoo.de" <lindner_marek@yahoo.de>,
	Joe Qiao <Joe.Qiao@watchguard.com>,
	Hao Wang <Hao.Wang@watchguard.com>,
	Bryan Phillippe <Bryan.Phillippe@watchguard.com>
Subject: RE: [ath9k-devel] [PATCHv2] ath9k_hw: Handle
 AR_INTR_SYNC_HOST1_FATAL on AR9003
Date: Thu, 21 Feb 2013 11:14:19 +0000
Message-ID: <1AA9BD91549CF94C901B05C32D2B08117B44B788@ES02Ch.wgti.net> (sfid-20130221_122644_424922_D37DB3AC)
References: <1348756862-8788-1-git-send-email-sven@narfation.org>
 <506B0628.6070201@openwrt.org>
 <CAJ-Vmo=bu=j+=z_TAeE3--Sn5oAEbkEG-HDqK=6okR8xmmWpSQ@mail.gmail.com>
 <2629427.e28b8DS3gI@bentobox> <506ED3D4.7050107@openwrt.org>
 <CAJ-VmonKjxmquSUg99kAtPWVwHH-4zTooF1Xvj9mGUyjWL5pCA@mail.gmail.com>
 <20121005165152.GA4473@sven-atom.home.narfation.org>
 <CAJ-VmomfDr-JAMtgQmbEsSeF62W-dmsK7LRTJxNUUddOTqDayA@mail.gmail.com>
 <506FF3ED.6010906@openwrt.org>
In-Reply-To: <506FF3ED.6010906@openwrt.org>
Content-Type: multipart/mixed;
	boundary="_002_1AA9BD91549CF94C901B05C32D2B08117B44B788ES02Chwgtinet_"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--_002_1AA9BD91549CF94C901B05C32D2B08117B44B788ES02Chwgtinet_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I can reproduce this issue on my AR9300 chip using compat-wireless-3.6.8-1 =
without any patch except Sven's patch on ar9003_hw_get_isr() to handle AR_I=
NTR_SYNC_HOST1_FATAL.

I just start two hostapd to driver a wireless AP(ath1, see hostapd1.conf) a=
nd a guest AP(ath2, see hostapd2.conf), the hardware will stop working afte=
r I restart these APs a lot of times, the number of ath9k interrupts stop i=
ncreasing. At this time, I can't discovery these two SSIDs on my client PC =
even though hostapds are working well.=20

just start one hostapd seems don't have this issue, just start two hostapd =
to drive two wireless APs still have this issue but rarely to reproduce. pl=
s see reproduce.sh in the attachment.

I can see "ath: phy0: Failed to stop TX DMA, queues=3D0x001!" in the dmesg,=
 which was output when ath_isr() receive AR_INTR_SYNC_HOST1_FATAL and try t=
o reset the hardware.

I also record the register access like what Sven did, but I think it is dif=
ferent with Sven's case, since nobody called ar9003_hw_ani_control(), pls c=
heck the dmesg info in the attachment. I also test Felix F's patch on ar900=
3_hw_ani_control(), this issue still reproduce on my device.=20

here is my register record when the issue happened,  just need to trace the=
 reg whose address is 0x4028, after 4 times ath9k_conf_tx(), I receive a AR=
_INTR_SYNC_HOST1_FATAL value.=20

time, record idx, line, func, Begin|End|Write|Read, reg, val, pid, comm
[  214.856089] 3116.[0454][ath_isr][B] 0000 00000000 0 swapper
[  214.856102] 3117.[0760][ath9k_hw_intrpend][R] 4038 00000002 0 swapper
[  214.856116] 3118.[0189][ar9003_hw_get_isr][R] 4038 00000002 0 swapper
[  214.856130] 3119.[0192][ar9003_hw_get_isr][R] 7044 00000002 0 swapper
[  214.856144] 3120.[0194][ar9003_hw_get_isr][R] 0080 81000002 0 swapper
[  214.856157] 3121.[0198][ar9003_hw_get_isr][R] 4028 00000000 0 swapper <-=
- REG_READ(0x4028) =3D 0x0, no problem here
[  214.856171] 3122.[0234][ar9003_hw_get_isr][R] 00c0 81000002 0 swapper
[  214.856185] 3123.[0781][ath9k_hw_kill_interrupts][W] 0024 00000000 0 swa=
pper
[  214.856200] 3124.[0782][ath9k_hw_kill_interrupts][R] 0024 00000000 0 swa=
pper
[  214.856214] 3125.[0784][ath9k_hw_kill_interrupts][W] 403c 00000000 0 swa=
pper
[  214.856228] 3126.[0785][ath9k_hw_kill_interrupts][R] 403c 00000000 0 swa=
pper
[  214.856243] 3127.[0787][ath9k_hw_kill_interrupts][W] 402c 00000000 0 swa=
pper
[  214.856257] 3128.[0788][ath9k_hw_kill_interrupts][R] 402c 00000000 0 swa=
pper
[  214.856271] 3129.[0566][ath_isr][E] 0000 00000000 0 swapper

[  214.856284] 3130.[0371][ath9k_tasklet][B] 0000 00000000 0 swapper
[  214.856297] 3131.[2876][ath9k_hw_gettsf64][R] 8050 00000000 0 swapper
[  214.856311] 3132.[2878][ath9k_hw_gettsf64][R] 804c 0004f6d1 0 swapper
[  214.856325] 3133.[2879][ath9k_hw_gettsf64][R] 8050 00000000 0 swapper
[  214.856339] 3134.[0445][ath9k_hw_addrxbuf_edma][W] 0078 18a38040 0 swapp=
er
[  214.856354] 3135.[0828][ath9k_hw_enable_interrupts][W] 0024 00000001 0 s=
wapper
[  214.856368] 3136.[0830][ath9k_hw_enable_interrupts][W] 403c 00000002 0 s=
wapper
[  214.856383] 3137.[0831][ath9k_hw_enable_interrupts][W] 4030 00000002 0 s=
wapper
[  214.856397] 3138.[0833][ath9k_hw_enable_interrupts][W] 402c 00023f60 0 s=
wapper
[  214.856412] 3139.[0834][ath9k_hw_enable_interrupts][W] 4034 00023f60 0 s=
wapper
[  214.856427] 3140.[0837][ath9k_hw_enable_interrupts][R] 00a0 81800175 0 s=
wapper
[  214.856441] 3141.[0837][ath9k_hw_enable_interrupts][R] 0024 00000001 0 s=
wapper
[  214.856455] 3142.[0428][ath9k_tasklet][E] 0000 00000000 0 swapper

[  214.856469] 3143.[1396][ath9k_conf_tx][B] 0000 00000000 2639 hostapd
[  214.856483] 3144.[0404][ath9k_hw_resettxqueue][W] 1040 00101c03 2639 hos=
tapd
[  214.856498] 3145.[0409][ath9k_hw_resettxqueue][W] 1080 0008200a 2639 hos=
tapd
[  214.856512] 3146.[0411][ath9k_hw_resettxqueue][W] 09c0 00000800 2639 hos=
tapd
[  214.856527] 3147.[0418][ath9k_hw_resettxqueue][W] 1100 00001102 2639 hos=
tapd
[  214.856541] 3148.[0436][ath9k_hw_resettxqueue][W] 10c0 001005e0 2639 hos=
tapd
[  214.856556] 3149.[0517][ath9k_hw_resettxqueue][W] 0a44 00000001 2639 hos=
tapd
[  214.856571] 3150.[0034][ath9k_hw_set_txq_interrupts][W] 00a4 0000030f 26=
39 hostapd
[  214.856586] 3151.[0037][ath9k_hw_set_txq_interrupts][W] 00a8 0000030f 26=
39 hostapd
[  214.856601] 3152.[0041][ath9k_hw_set_txq_interrupts][W] 00ac 00c00000 26=
39 hostapd
[  214.856615] 3153.[1421][ath9k_conf_tx][E] 0000 00000000 2639 hostapd

[  214.856629] 3154.[1396][ath9k_conf_tx][B] 0000 00000000 2639 hostapd
[  214.856643] 3155.[0404][ath9k_hw_resettxqueue][W] 1044 00103c07 2639 hos=
tapd
[  214.856657] 3156.[0409][ath9k_hw_resettxqueue][W] 1084 0008200a 2639 hos=
tapd
[  214.856672] 3157.[0411][ath9k_hw_resettxqueue][W] 09c4 00000800 2639 hos=
tapd
[  214.856686] 3158.[0418][ath9k_hw_resettxqueue][W] 1104 00001102 2639 hos=
tapd
[  214.856701] 3159.[0436][ath9k_hw_resettxqueue][W] 10c4 00100bc0 2639 hos=
tapd
[  214.856715] 3160.[0517][ath9k_hw_resettxqueue][W] 0a44 00000001 2639 hos=
tapd
[  214.856730] 3161.[0034][ath9k_hw_set_txq_interrupts][W] 00a4 0000030f 26=
39 hostapd
[  214.856745] 3162.[0037][ath9k_hw_set_txq_interrupts][W] 00a8 0000030f 26=
39 hostapd
[  214.856760] 3163.[0041][ath9k_hw_set_txq_interrupts][W] 00ac 00c00000 26=
39 hostapd
[  214.856774] 3164.[1421][ath9k_conf_tx][E] 0000 00000000 2639 hostapd

[  214.856788] 3165.[1396][ath9k_conf_tx][B] 0000 00000000 2639 hostapd
[  214.856802] 3166.[0404][ath9k_hw_resettxqueue][W] 1048 0030fc0f 2639 hos=
tapd
[  214.856817] 3167.[0409][ath9k_hw_resettxqueue][W] 1088 0008200a 2639 hos=
tapd
[  214.856831] 3168.[0411][ath9k_hw_resettxqueue][W] 09c8 00000800 2639 hos=
tapd
[  214.856846] 3169.[0418][ath9k_hw_resettxqueue][W] 1108 00001102 2639 hos=
tapd
[  214.856860] 3170.[0436][ath9k_hw_resettxqueue][W] 10c8 00000000 2639 hos=
tapd
[  214.856875] 3171.[0517][ath9k_hw_resettxqueue][W] 0a44 00000001 2639 hos=
tapd
[  214.856889] 3172.[0034][ath9k_hw_set_txq_interrupts][W] 00a4 0000030f 26=
39 hostapd
[  214.856904] 3173.[0037][ath9k_hw_set_txq_interrupts][W] 00a8 0000030f 26=
39 hostapd
[  214.856919] 3174.[0041][ath9k_hw_set_txq_interrupts][W] 00ac 00c00000 26=
39 hostapd
[  214.856934] 3175.[1421][ath9k_conf_tx][E] 0000 00000000 2639 hostapd

[  214.856947] 3176.[1396][ath9k_conf_tx][B] 0000 00000000 2639 hostapd
[  214.856961] 3177.[0404][ath9k_hw_resettxqueue][W] 104c 007ffc0f 2639 hos=
tapd
[  214.856976] 3178.[0409][ath9k_hw_resettxqueue][W] 108c 0008200a 2639 hos=
tapd
[  214.856990] 3179.[0411][ath9k_hw_resettxqueue][W] 09cc 00000800 2639 hos=
tapd
[  214.857005] 3180.[0418][ath9k_hw_resettxqueue][W] 110c 00001102 2639 hos=
tapd
[  214.857019] 3181.[0436][ath9k_hw_resettxqueue][W] 10cc 00000000 2639 hos=
tapd
[  214.857034] 3182.[0517][ath9k_hw_resettxqueue][W] 0a44 00000001 2639 hos=
tapd
[  214.857048] 3183.[0034][ath9k_hw_set_txq_interrupts][W] 00a4 0000030f 26=
39 hostapd
[  214.857063] 3184.[0037][ath9k_hw_set_txq_interrupts][W] 00a8 0000030f 26=
39 hostapd
[  214.857078] 3185.[0041][ath9k_hw_set_txq_interrupts][W] 00ac 00c00000 26=
39 hostapd
[  214.857093] 3186.[1421][ath9k_conf_tx][E] 0000 00000000 2639 hostapd

[  214.857106] 3187.[0454][ath_isr][B] 0000 00000000 2639 hostapd
[  214.857120] 3188.[0760][ath9k_hw_intrpend][R] 4038 00000000 2639 hostapd
[  214.857134] 3189.[0767][ath9k_hw_intrpend][R] 4028 00000020 2639 hostapd
[  214.857148] 3190.[0189][ar9003_hw_get_isr][R] 4038 00000000 2639 hostapd
[  214.857162] 3191.[0198][ar9003_hw_get_isr][R] 4028 00000020 2639 hostapd=
  <---- REG_READ(0x4028) =3D 0x20, raise a  AR_INTR_SYNC_HOST1_FATAL error

I did some tests, such as
1. add delay(1000) after ath9k_conf_tx(), but can't resolve this issue.
2. add a spinlock sc->sc_reset_lock to protect the hardware between ath_res=
et_work() and other reset contexts, but can't resolve this issue.

Now I have no idea what to do, any suggestion will be appreciated.=20

- Felix Liao

-----Original Message-----
From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@vge=
r.kernel.org] On Behalf Of Felix Fietkau
Sent: Saturday, October 06, 2012 5:04 PM
To: Adrian Chadd
Cc: Sven Eckelmann; Simon Wunderlich; linux-wireless@vger.kernel.org; linvi=
lle@tuxdriver.com; mcgrof@qca.qualcomm.com; ath9k-devel@lists.ath9k.org; li=
ndner_marek@yahoo.de
Subject: Re: [ath9k-devel] [PATCHv2] ath9k_hw: Handle AR_INTR_SYNC_HOST1_FA=
TAL on AR9003

On 2012-10-06 1:48 AM, Adrian Chadd wrote:
> On 5 October 2012 09:51, Sven Eckelmann <sven@narfation.org> wrote:
>=20
>>> Well, is it a RX chainmask thing, or is it a chip thing?
>>>
>>> It's totally possible to have an RX chainmask of say 0x2 or 0x4..
>>
>> What are you trying to tell us?
>=20
> That the check for "rx chainmask =3D=3D 1? Definitely can't do MRC CCK"
> implying "rx chainmask !=3D 1? Definitely can do MRC CCK."
> I think that's the wrong logic. It may be a general chipset problem
> across some/all AR9300 and later chips that doing MRC CCK with only
> one RX chain enabled is a problem, or it may be a single-chain NIC
> problem.
>=20
> I'm pretty sure we can configure any of the RX antennas; it doesn't
> have to be "one chain =3D=3D chain 0."
>=20
> Anywy. I'll double check that.
I'm pretty sure it's an issue specific to single-stream chipsets, where
all MRC functionality was left out (and thus the register access leads
nowhere).
I don't think this needs to consider multi-stream chipsets with only one
enabled chain.

- Felix

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

--_002_1AA9BD91549CF94C901B05C32D2B08117B44B788ES02Chwgtinet_
Content-Type: application/x-gzip; name="debug_failed_to_stop_tx_dma.tar.gz"
Content-Description: debug_failed_to_stop_tx_dma.tar.gz
Content-Disposition: attachment;
	filename="debug_failed_to_stop_tx_dma.tar.gz"; size=40721;
	creation-date="Thu, 21 Feb 2013 10:10:38 GMT";
	modification-date="Thu, 21 Feb 2013 10:10:38 GMT"
Content-Transfer-Encoding: base64

H4sIAJ7yJVEAA+xc+XPbxpL2r+RfMXE2XkrigfuwQ9eTJcZWWZIVHeu8UlR4IDAksQIBGgAt+SX5
37e7BzxF0LTAaLdqjbJ5DAbfzHR/3dM9M5TPu+O+03ODkPtOFjtpFo+c7N7xh27r2ZYuCS5T1+Hd
0DUD3xVNU2Qqz69nsiLLsmpKhgr3ZcNUtWdM31YH1l3jNHMTxp71wsCN19Q7jIduELGrlCfpU/Tr
iS5/jf7FPbVpNK2G3By5mTd4VBuoYMMwCvSvKpqq5vrXddnUnkkKvJrPmLTlsa68/r/rP+j1WKPR
DzLmtrx4CFpu3AUJD3maNnLVt9LEa/lJ8BmG3op41ppUaLnZAP83B6xb4uFqEPn8nhmyYfe6frPZ
c7uu7GlMBsJoWrXRaJTqW3Vvb69c//7xD9ZQLLuusT18MxkUAG2ywGNBFAYRZ14cpRnzBkClXXjG
iUfD2OfCoJIg6td4NB6yKLSA27IT9LIvI85EpZ0q+6vKfuQRqKLKqnuf48BnCe87rudBNxzX92tB
lDFsp77QUG8ceYsl8ajOxqqCj4sPn91w59VDTH88HNWwEG9OGmetXbZ/+c55x3Zb1a3wwr5tdbkL
HWx6JRQwh5IzRe5qliZrzaaiypqiq9thynw75Sgzj4TcURW1brA9fLOQO6QOqueIek7mprchz2rj
KA36EfdZGEd95ruZC/SoVBKejZPoFXz8CylSWaKH4xwfnXYcp84cB0mBn56/eV5nEvwTKq60duGF
7bKDAfduGWg7G3A2SvjnIB6nTHSDDdyU9WPgczzOmowd9cQzUZwxP47+M2NZ8oVlMRvFQDkXigc8
qbP0NhgBXJCyEU+C2Bdj1uy6DAaj6nJdNh816oqo/GnMx9xJeAo1UyD8eeeic+lc/vOs47zp7B98
OHUuLq8O3u+geHL5bCSgzkxAD0TMKmkIg24v9tcbxHHKHbwFPaHnPoMk2yz1Gq9zjXfx7jW+3MD9
aqMCFWo/YLU//2T4DjWhV1C11+SR2w15jr4D/d64Lvuj3Cj38lF2e8tj7POIJ27GazimwV2dQTfo
2Y/756fOh9PaD138jirWJB1prclS/XEKpuFyCDXm1T24g/gDJ+Ws5g7qC6Klt087QkmbWcH88GnI
ud9+2NcgCkCrWTL2MrzhpHEv89guMg49acTvs6ybZeIbOGR0rVtzk4O7UnNojpC7R58btmH1ms0u
eEVfsbfmHqmN0q6RUJA/JngG4A+8qRLwB7UDU9A57wdpxhOYr1y/dZcEGfqpYBhkgJri3MR+9HkP
Z93zzlvn4/nRZafmIFUcmvYcVAz7HSwPS3car5Em8ShtElSNCuusRtXwHW7voO3V/oCHwKi+4alX
9ARjGzHxIzCRGqjM9TNH+GsHBz8/rPPO/uFsVCvHg/KZdWwyDJaPA3qFRMVWwMS//ug3jeV8zVhY
Bb9NvqwemXNydXx5lI8PWkkEBLx6UbZTqfwOFr7U5eE4zAJnseP45IJW8OmHDZ58XOAHzCPYUJis
lurwblEy+A6PCHx4aJ4rayT8VZhcQhvJ+2SNvOfFvSjtzun+m+MOCPwtGYnz5uqXXzrn1KsKXihl
P2Z/VPLr9625M0yVysZ8AmOaG3DJ4gZEfGbP4l19ay4tb6W0U8txKPIxLIr24G15Wlw/HyKbcHqC
eEyEFDDLJKLgVX47uR8CxKvHBIEsn19HqXPn3vLxaBLCpKMgcsLYu629wEZTzxl5YyrA22KmVzSa
6RVdDAnCw5ciSsJnx1Hh07M2IX7L4oSLRh85dwfJJxHAOGKKDtKEUiMorwsx7/r8847oMsSfigR9
hvhTMbDTmz7NKpSsiZ5jhZkKunEcgmYGoLk267lhyh+pikk0fglBOGRu/p2bcAYBNEba6OO+tEYY
8EbgqSjwFrWzeOwNIO7+AsF21G+y0xjmRgq8PReD99GIR4y7SfhF1IeIPg/0j85/RfgU2uJ+k+62
8tg0A8U4XYh9Lg6cD2fO0el/7R8fHdbZRJ290O2nO5PodMPa5eJT7K5z+uG0MwtUITAQnRfqQjn1
4oSNRUAwCbOnESRaDgjDhxBy2vWCu1vv6goxvfvoUNayNTlNh3IbhCGOhyfJeJSlOKLl3r3bPz08
7hyKqJlMw5IgD93TLKsuS99mGUCqI2IU0BUpG8UTjwWDBX7h1Ap3I8HKab/YnUvcFgiouCFntXQQ
j0MfePuZQwIKD3nuuD+ALnTjz3xnkaU/iGamusy//h08O3DBwMlq8qEhwyqL/hgddO4VUKK6Tgm+
bqjCP3qDYCQy1pfYWu72HfIc45ALV4loTjZJZzZ1IwvjWKllCADGMGn22MXBu84hmOjlOXXSkGXs
pKEoSytYWe7rRNKVp0AB51ysVg3u2O7gDrU/y46gtjdwo4iHbBcTp8k37BQCJo+fohy/26/BTDyM
ozqD7P6Xo7d1FOLzC+xegPMlTcXsLsgGDBsPIADL23/JfvLZybt//x49p4e8cYJ3Gq89jlx0egn/
lGevhk06M6V8ThuOM36fz2Vicls9d5VRVJLPZJT9SDSnmrK5oI75aOG+SBmQFosbKaSvY4jZdtPb
7pyG5ur7CTwALxChrr65AyDdxmsMQijKWAhNyE09Updop8hzEKBYvPDRXEEpNPmhIxi6HnUE5jgu
5j6wGHZ2wnoBB8eAfiKKkyGoF3vHeok75CmMPWZ3XMjQ0Os2yNC064CyLSFW+nEWM34fZKVNEz4h
DnqBWfNAQo5rHLfdGvUCWn10SPRwwLiDU2zEJDXTJObZahHz1mPMOwJHWCrbzd8nq0kwNYmSyYxE
oROuNzqBHz42bBI2Oos26TvZpHAdEAZ5PHTu4uRWGCsO19LI0C1Deuxw513D6oZX+Cz2/FD4qYEb
ZuCPHq9jEp3o6Tjlab5gldIUjRsJQqu2RatxkBipBf4dWhShQs/1eKFVPE695PQ5rphK281OilWO
g5YlsbQuS1rRrLbpqEVOs07XW0tmptMBz+YmBFlScw3qesFYcC7r8+0rMQ9Kt6nL1SZxQANgR5MB
CLtga/QsJGMoQjJWEbe/QTK5ogtm9zUE2J6iTVkMp9gDJ3wIQfA3a3q6aA3KG9zB3Asu6FUZMmxV
+4c8g9h6lfZXGr+QVe7W4MMWZPVEBl4wNed7OKN05T6DcOOyrAquy7pRxPU46gX94rAGF4qEPfgr
Y0J8HvUf4ebPC6QJfp5O0pS3TMP7cuscj3PqikIBiqzoRU79G0VACbMDueiUk8+vSBe4mYkxZz7a
nJBQfx1LKoU8eUwqOvERjQ4tpkx3MYUkNEtIwtS2Iokn4v/M80lkDTQW1TBoLKpd6MRhLOsC9jyp
oA1h9rrNPp50nNOrE2f/YG6X/NGTVnb/KV93ze6b8MUZuqNrauvma05KtSUamiZbjx7ak6tmMinR
CExVq8sWDME01LpSkEv1wnE6KKYaeQ8/iUc7eRAR1Nl/T92Kn7hBBCL4tO3Yv5JH/T4P3S/cp+jf
Sb9EnqiX3ePENgp5xulWLgQkkjtovHYHYi2OvWD775yr07Pjq7dvO4d5qro8le2f/pPmsc+Bx+m0
BK1bjaNROO6Dhf0wdSDroogtnE74tqXYrw0EM+98vflpBiAoZ9ECiGzJRtHM/g2EW8iwxZGReUJQ
pr2SD4v82k7cNz//z2Vv0LRYw3Bw9RmPhRUmndvaibsfBlnZnTiBke/EWVbXAFE0m3rP6ErbOqU3
a6X0TlyOQ2f2FFPHJe498UGZ341DZUy241ZHY2LH7ZM3xi03XD+ryeznn/GInP2epp3L35xfrzpX
nYsd1mDyDngQdChiWff+UzpJpYJHOjxc/qoFlIWxgK1sGG7s7eUWji4Bj+9d/varc9G5vDqjw1IB
dOsFTJn5KOAjDSLY2ZnFRSCJURJjzz7RMy9mc+B1cFPuuM28uPGkz1dkLrRmU3oE7+riDuqGINOQ
NwzAQw6467Nuj94nKpnu6D1aL69ezYl9090ekng34e6tiBsUVSxNwbvxyJEuKZAWMnlCagT1QQ+y
FPxkDz7kIpjuHyFHc3c3dYiT58rpvLW7fG3jPGm5MwULpwm8nm0Zitpsaprh2pq1BR9W/hzB3AkC
kf7Aq6kiKU4+HF4dd5z9q8t3H85rz/dx+y1O2QFM5eMo8GCWiaOUpu285mHn4uD86Ozy6MNp7fmF
2DYNg27iJl9oUX2CMGmfHe+fMs9N/LQ5D3N8dNA5vejUnh+O3ZC9uThsvT07Fhn7Hq474h5Tzss5
nkR48DnNaGducm4Z59DZmeXZt3iEn/MTy5OPeJwlf3YU+NPKGLlcX+5fvHcOPpycOMedUwjL9/56
0HSG51335gLwuQpehHfze3h2gdi/UAVLZnUegM+XZJhBXmuSbdxQm0uN0YFCOmRd3ftj0ZagH2J1
bW92+kLUf7HUFQo/hnyIh1+Xmyazw+bZLkuDf/O4V3vQ3x06/rs3lxvt/YUFwxg3IkWbS30WT2z9
GLoQwsrtpQXZ5HLeDd00q7Nd/CqGMCep5FPqfuYPhFUXgCQzfA6XNx7oa1ENN5O6jdd0kL895aso
xMHhGkhOW1EYj6BIcFcUACaU5BwWReJUWM5lUQRshiJvnCQQaNNXIkCWRN7oS03UQZbXZ3XE1wXW
U6zx6gGf9vYelrGf2sSPKc9yd0/7/SKLXCNC4Ennt7MP55fOxT9P3nw4ri2yYTVNZr8sEPrOA6Bv
UfxjNT5KoLHb2vN2G4WcMTqkUKNN7R0GhZM9GBFXtTGq+nnJN0zCKUhxCvkTEGWmrf0kaX7zGl9v
rn9K6T+Db/fwYt3jbvRPKW1G4+JQJcCTKxOuTT4L+5kwK6855dXkDh2PnPJo8hH5sSNOLxQJADKN
heG3WmKFj044JNyLE5/RyApdVFn3s2XuIcXEjxqW928xqknu4bPjhgBYK1z1prMB4vhmyCff+r0R
0A9fMVTeqf5v/zTrSa51v/8bxGA8I19u4uJViTbo93+aVvj7T8OQ6fd/UMlQTAN//6eq33//9yTX
jyzXMhMLyeOEwknWA0KwyW9BIH/6ggHkJF6sTrda2mBbclXEtO38523VbhL4fd7mcKshPlfTNPDb
+2dvzj+cdi7fyVWYCsADON0kdn0PJnqHKkjVrniXXtrSS7P30tZeGv5LiVerXpaEsx2eduuzm7SS
cVRFZ+BgZ9utbDiaULaJxdXqj+zj2X4L/iu4yI9nh9Lq3chtq1XujuLQwUAcBttWsNQZuWk6GiRu
ytt3PAzTnpv0Y7pzy784w/4wawNU4+zifV49SO4CqHz5/uiMHRycnGGDiesHMaTZJIkIggQKzquD
Owd/69fuV6dLPVFbrubbDm2rmmTgVQfgGQdx6LcxIaz2Erc/XC7ctlfawP6Vv93+dS3//a+hK5oq
7F/9bv9PcW3B/pVl+8+N/e0Y5vmvWbqybOnuyAnSOIRWwT6e2Oy7bnQb99whTyCr/j9n+X9LQLLO
/hM+SiBN9HgzfdwP//PrK3//QZY1bfr3H9DwQUaKbny3/6e4fvyh1Q2iVjqoVvEoOcTNE4cw/Y6U
T8ejUQhGEWUwu3tZyHwedhM2P8UvlSsF5eqkPL8BmeRKoGm5UlC+AijozQPR5+WbytxNZfmmOndT
rVb9IU/7rOGx14w+Ot04zpph3K/eDdA9XjOZ3VT9uFrx3Iy1cAm2NTuKz/5kfbAgzD6qlYmTXQip
WSNjDZ813jP59ewO4LMXD55QCp9QJk9UK2nIoUG5WsGVY2HT7X+JUeSdOTzZ/1cV16yvWSNiz/9j
VvE5DKWCR/erlYp4ZDJqXIygUVcq3BvEbO6har6cXa30AuzAMoX8OOJ/j9/6fm3nWuf/L+Xt/Amg
b/n7P6apPJNkU1GU73//5ymur+h/0QM8so218b9sqqo+079qQLmiSIbyff5/iuvkBgJW2WOywkEZ
SpcphmpP/fc1Y4qsNS3NkDT1hkFypjWvZVvVb66np0ZpMfHmmoAkjXUtC+I5RSkE0k0C0gFItrU5
IDx1CLQjKElSJYYdkiRLL4QyFYIyAAroUwylsdzNFENZBkGZBGWsgvoIA4RQVUBBv4qgZEkiKIug
7MJeydakV3IhlKwRlI1QivRVKHkNlGIhlCY1r0GV+hJUco8rqLiIS+MEQ5UEomkZhYiCEZqMnVNX
jhNFpmoTqDUiE5zQFOicbpjL5BJ/DyQbpw7+KSXRQwv4IduGCpwrhhX80FSCtTaD1QjWs9bAWqK3
ZAqa9NAUAEiTrKl6rSIgRZIJSCcgdaVNAdW8XLk9rRBI1gnIICBtDZDprwdSbAIyUWIK6jSxwX7E
b2aDzOl2b67Pb5ir6LkdWHbx6DQir2YhlqqsxPqIWJL3VUNQdMFeMATJ1qwHWJ4b0iBdQ0OxW0hg
txBM0EJHUzBVYx4MJr7gE6I5yTgSQ9X0qSILGaEIRugyImrKGkTRR+mrA1Yl0Ue0CNma59idG2Si
ZxvhyOTXdLUsjiCGrpXFEU5D18viCI+hG2VxTDJB3SyLY5EF6lZZHFvI2S6Jo8kkZ0Mqi6OQnA25
LI5GcjbK8hmYQzhl+awZJGejLJ81S8i5LJ81m+zUKMtnXabgwyjLZ10h522U5bOukuM2yvJZ18kf
mmX5rBskZ7Msn3WL5GyW5bNuk5zNsnyGAJZwyvIZIgDCKctnQxVyLstnQxdyLstnwxByLstnwxRy
LstnwyZ/aJXlsymRP7TK8tmUyR9aG/K5MBKCZJ5wkM+2Ka8O1JaivmIwjSYfSyMwdSOw4hEaxGwL
mW1bBT2j2NbD2FbWLd8vjG1Nk+htGd8AZheC5Vww14F93BDMygmxjugb4eSEWEf0jXAEIex1RN8I
R3DBXkf0jXAMEra9jugb4ZgkZ3ud494IxyI52+sc9yY4tiTkvM5xb4QjCzmvc9wb4ahCzusc90Y4
mpBzWT7bupBzWT6jH2KKLpXls00poy6V5LMp0RqCLpXksynREoIuleSzKVGiqEsl+WyK9UZdKsln
Uyw36lJJPpuSKeRcks+mZAk5l+SzKdlCziX5bMqUKELaUBaHEkVdLstnmRJFXS7LZ5kSRV0uy2eZ
EkVdLstn2RJyLstn2RZyLstnXC9HnLJ8VihR1OWyfMYVZMQpy2eFEkVdKctnhRJFXSnLZ4USRV0p
y2fFJj4rZfmsUqII6X1ZHEXIeQM++2txVCHnDfi8HkcXct6Az+txKFHUlQ34vB7HFHLegM/rcWyS
s7oBn9fiaBLJWd2Az+txFJKzugGf1+OoJGd1Az6vx9FIzuoGfF6PYwg5l+WzZgo5l+UzZEyEU5bP
EIn9D23XsiTHjWt/pT+BbwLbG3GXs/HGq4mOzKpMjWJkSSO1ZnT//pIHVf2wmqiEi+ONrQjrBIoE
wAPiEAmce/25ZXjg3OvPvRPUcNK9/pwT1jnd68+5YJ3Tvf6cK9Y53evPmbDO6V5/Lk7W+V5/Ll7W
+V5/LlHW+V5/LknW+V5/LlnW+V5/Lmgm5nyvPxcIEHK+158r1AdZbRwewoH0IKuNw0M40B1ktXF4
CCfJOt/rzy3ggXOvP7eFBs69/lxJ1vlef64s63yvP5PHOquNw0M4AeusNg5f4YxuWtvyoE5B47At
+vut9f45IkxAuFxUU78ObsxgdachrvgBGontD/Nw5Z4AjcW+J7dwuyAg1psX65UkP6DRSC4esZfX
BrfH1IVdQ3tZ7o/QeCRntne4b3KPmNGI7D511F6g1rIPcYU/oDE5c305ib1sWt/uvztx2s5DXOGV
aFxOXd8Ke9HIPL6+otrx+zZeB6k30NicuL7kpO5Eo/P4+tJDN3bd99H6kgu4V0Hjc+L6NhPF3mxa
X5EK7aeh/JFcFnvL3LxDroi9dfa+yb0VGqfH9+30sLcf2jZ9G+LK/WXlyfsmksmMxurxfbu0D2kf
5Z0GBXvRaJ25vl74LBqvh9fXO+SdtZUJQ1ypayjOXl/0vTJ6sofX1wtuCHG8DlLvoj07c32DE3uL
aX3bsvK++30fxluQexA0bWeub4hiL5nWV/L6vtIw74SMcx793Jl553JPiv7u1H0j2It+7/F9o4e9
9w6cH68Di71h8r5FuU9HP/j4vl2kpZyGeScKj+bJfJKi1FNs4pO++8POJfthXhdhZubJfJKi1Nls
4pNe8nrwebwO0oflyXySkty/sIlPhq5p3/ew7yPxciuHur3FTeaTlKDTKM7EJ4O75J11GG9yP1vQ
n56Zd1IRe+PsfatibzLtW3rYU3ZRyTuJxd48ed+yE3uLad8u6n3Ow7wjAtDiZvPJjD5fcSY+GVpe
33de8nh9cxZ7Z/PJjP5v8SY+GSSvB7eM1xf3PsXP5pOZxV4TnwynBx/3PSp5p0AfUvxsPin3wsWb
+OTlScy+LkN/KEnszZPzTilib5m8b6WKvdWyb41Ob3uOq5J3Cou9NHnfKvqJBf36w/sWL7iLH8ZF
DZ1HlTCbT1b0mUsw8cnY8vq2c6uzRvecVLPYO5tP1iL2mvjk5aFjCGM+WUnsnc0nK3QpJZj4ZGw/
f933su/DdZD76BJm80kKYq+JT8bL/c5ahvFGSeylyXmHstjLk/eNoGcs0Zn27dTyTjsLnB/ePxD6
mCX6yfsmOtcC/cHxfbvc76zjuGAv9s7mkyy8Opr4ZHKd71B3zyGu8Oo4m08y9C8lmvjk5WFAqOfx
+lbwkjibTzKLvSY+mdIDpX1347zTMMTeyXySnfDqZOKT6XK/swzrrBYWsBd6iIl9MnbQUZZkqN/W
Q7jon5Y0Od5Y9LUlGeJt6X2nsJXl7MqI/7K86i9pcryxF16dDPG2XPtkfnyfyl54dZocb+yhuynJ
EG9L7zvFuJ/O5TTKZ+zxLqOk2fHmoccq2RBvy7VPFpOyvni0U/Lk+o2D8OpsqN+W3ndKi4th3Cfj
ILw6T67fOETwkmyo35bnPhnnOMSFjrdkQ/12KO+EIvZOrt84kNhrqN+WbmZsFU9xZRgXQXh1nly/
cYTuv2RD/bZc+2Q+LsN1iND7lDK5fmMZHFCKoX5bet8p0r6FGodxEbPYO7l+4yi8uhjqt+XaJ4v1
PF4H4dWz9SWcoBMtFn3J0vtOlF1qeWfE+zjhHWGZrS9h0Q8Xi75kee6TNVI+xE1ir6F+O5R3kvDq
Mrl+4yS8uhrqt6X3nSKV7eTKeB3w3qDUyfUby4CCUg3123Ltk/X5YEPcIPbO5pM5ib0mPul7Xm/1
RXWj+piz8Oo6m09m4dXVxCcvfbKY9/E6CK+erS/hAv1ZsehLlt53Ko2klX0f9SFZdMtltr6EC961
Fou+ZHnuk/E43orwatGXTMw7BfqzQpP1XFygPytk0HMtve8UQzmzG96fcWGxd7Kei6sTew16ruXa
J+uz8Ya4QeydzScr9GeFTHwytLye9r0FxmgMAlfozwrN5pO1iL0mPnnpk8U87M9zhf6szNaXsOil
i0VfsvS+Uz67REqdRcKrZ+tLmIRXW/Qly3OfrHnTEBf6syL6kol5h/DevvBkPRdTFXsNeq6l951i
1OssmcNQeLKei1l4NRv0XMu1T+ZTGq4DC6/m2XySoT+rzsQnY8vrtfOdNMw7jPeZ1c3mk1zEXhOf
vPTJYh3ndSaxdzafZBZ7TXwy0gMVl3jfB/NZc5/9Cdy5fLLhQn9WLfqS5blPxn6Qdxou3nVU0ZdM
yzsNN4u9c/VcDbeKvQY919L7Tr5VwGcXB/Vxw8W7jurn6rlyc4cAXIOea3npk63DdfDQn1U/l082
3Cj2mvhkS49+2/eQwnB9fRJ75/LJhlvEXhOfvPbJ2u4McavYO5dPNlwWe018sved+kSXoQ46t99C
wJ3LJ3PXigPXxCevfbL1PKgvGi54dRV9ybQ+WcMFr67BUL+dDuEWsXd2vAXoz2owxNva+05+qa0a
Gul3Gi70ZzXMjrfoxV5DvK3P78kWGq6DDLatYXa8xST2GuJt7X2nfd/LqY7edTTcLPbOjrcI/VkN
hnhbn/tkNPaHCP1ZjXPrt+wS3nXUaKjf1t53orqfo5LPZL5FjXPrt4yZ6x3XUL+tL32yUf3WcIVX
R0P9dijvJOjPapxbvzVc6M9qNNRvK8yMtZVFfqDDa7gs9s6t37LLXuw11G/r83uy05hHZeHVcW79
1nCFVydD/bai7+T3mutpUL81XOjPappbvzVcvOuoyVC/rc99slMYrwOJvXPrt+xkrka16EvW3nc6
rft5H95XN1zh1ZP1JQ1XeLVFX7I+98noNMw7Bfqzmgz126G8U/Cuo6bZ9ZsM7q3JUL+tve8UGiFf
nB/oghou3nXUPLt+q8Krs6F+W5/fk53H9UUVXp1n88kK/VnNJj7Z+05h729uhnFR8a6j5tl8shax
18Qnr32yZdSHbLjCqyfrSxqu8GqLvmTtfafV7Vsd9udz++1i72w+SdCfVYu+ZH3uk9F5mHcI7zqq
6Esm5h3Cu45a5uq5Gq7w6mLQc6297xTa3yGlziLh1WWunis7Fl5dDHqu9fk92Xm8Dgz9WS2z+STj
XUctJj7Z+05xZ1fr0B84i72z+SQLry4mPnntk/HovjpjcHjHnc0nWXi1RV+y9r7TQvvG47zjHd51
1Mn6koaLdx3Voi9Zn/tktI7yjndJ7DXMCzqSd7zMJ651rp6r4QqvrgY914o+Wa3ryYVRneWd8Oo6
V8/Vqiy866jVoOdan9+TbaM+WcPFu45aJ/NJ76PYa+KTve9EO8c60kE3XOHVNJlPei+8mkx88ton
O5XxOgivnqwvyfg0YMc18clID+eAdx2D/nyfDQEeNVlf0nCD2Gvik9c+GQ3vd3yA/qySYV7QobwT
oD+rNFfP1XCr2GvQc63ok5U+s9KP7SWxd66eK/uIdx2VDXqu9blP1kjYEBfvOipP5pMt7eCcZxOf
7H2nuLd/D+/BfYT+rPJkPuljEXtNfPLaJxvqrhpuFXsn80kfWew18cmUHmLe9zTuz3uZv1wn60sa
rvBqi75kfemTjeYFNVy866jQl5S3H6UBbof99GU5Py7//vAYHr8u379v3w+3y3xCu4wgM+nfMDoI
j88n5svt3/g2zSd0zQhqk+rYDN+I66rBo8gnGWpitT5drR+eURk5iUR7YrU+wfqqwUMaS5CgmK2n
29YjQxGUKGbr6bb1aOgTBCn/BcfMRRyzmhdnfXbMbdhe8hlyfRJ5imlxBH7nvWrwUBcRVCpm6y+O
udXh2heIjMi7v2J9gvUqPHoiJDNRrNbT1frh4hSUcCTSFav13THXbdfg8ZKIoGD5LzhmwYMi8vao
PR1xzAL9I3l71Ap8y5eaY8p36khkLVbrrxlz7DkyNYR8/SvWd8c87yp8FMekv2L9s2MOuUHN4pj8
V6wXx1w1eDkMRfKCr4gfhefmkA9roOTWdXgYyo03ifIl/MpANPhzc5gbhEwuvgkCGJffwH/fnn58
7QTn4/ptefr45fMFtbdfE7tFQZVrb4L8pY9k1VHl43u3vgPdUIPYmoDKx231qq1JbMVnwn/9OjrM
87t7/sj9sJYkyVBd69JX/V2grjq+AuUhEC6XCOKWUMIroL7Rn3cZW7C1as6fY/A7D/MC4TqJIGcJ
Jb+D9PsbpDhqxHkZZE0QsAxtWoB02tqvHNvEKN0IkpWhTa+QRsN+G5L4A0QqQ5vWQzbh+StBljK0
6RVSKEMkXDgShCihpneQ/vb3l9HsbjiavSFBEkuQnoRa7kGCCJYgNgm13kYaeQHcuiP1cybQezb9
dsym4CRDQFASPWs+zmfNM4PD0w2ChCSG97zg9zdIQy8IcglNEI0MbRLP7AMrxp4ZRCZNkIkMbXqF
pNiECx+CMGRok3gmR80zg5ODBFKQoU2vkBSb5MyA+COE19HS/s9vT4+f91P/puprpxp/gyAH+UYe
QfMRAt8NJ/4AqUeI6SDc0L28OEVXePjk3vDOdX38z/J0+sf5y4fH05fP+8cP4iH19lkWvOSJLvDw
/XH4Ddjf38KO9IvBC43t+g6fojsGC1nk7hyNTqTg5RyBvKOPhH8F++3n4/Z5WT9tl/PN3f7tASIf
gqgjpfhqh5bz+dvP9cf+uJ3/WC6ANT144savhl2IEKDuIag5jgG2gz5pgFJkQ8ZxGDBrgLj/I+g3
Dv5kyqqFRSxMFkDSANFJJyg2jgFu7qz+ZLTQCVKNoxaWkwIYpciBRuPopuRdA8QjL4I44/AuOw0Q
UxMIqozDgF4DxLgEKpZIYXUNMSeBiiVStqIBokFFxRIpm/qTofiiYogUZm2XkxMLj0cKF1o0QLxJ
pnI8UvozfA0Ql8FUJFLyLUBqoZfOmh8mqXhLPQzIZa8aIGQVVMgA6LT0JTplKnwcsJ5WDRBCCqrO
AnhWAGWSBlVv+MlVO6RkhAbVYAGMGmASC6MFUHNsGfJMNVkAtU2R6c5UswVQS18y1pnq8UhpgOou
4506VUuk1E0BLEJm6/FIaemLNUChs/V4pDRAbZeL1Lp0PFIaoLbLRagsWSLFadlGPvpHZIkUr3Gb
IvSVLJHitU2pchtCxyOF+idjFEBpGpElUry2KVUYLFkixWuhV4XBkiVSvBZ6FZJQouORsqVVO0ar
MFgynCnFa8yhCoNly5myaecyYVoB8fFIoSVoxygJg+XjkdIAtdAjYbB8PFIaoHZIEQRXxIZIWYIW
KSQdRD4eKQ1QO5dJGCxbIoW00CO8BSY2sS8tUhjDdYhNkaIdASwMli2RsmuRwmCw7CxnyqL5oeiD
2RkihRdtU0QYzO54pLTyVvNDUQSzM5wpVa2XZXQFOwP7qiclY0eZWcHOcKbUsxLL0QWx0BIpm7LL
UaYqs7NECivsKzowWHaGOqV/rVEBLGKhqU5RQi/KB//Ym84UxW2iA4NlfzxSNnfSdlmuY9mb6hQl
UqKHZpy9hX3tyjEa5UqWvYl9qYBZLLSwr105U6KvYqHpTNF22aOFw94SKaRQ4hjAYNkfj5R9Vf0w
eLHQxL60SAl44sTBECnFa7Ec8LaJg6FOyUlz7FDEQgP7wlOHMSCmb3EwsC/K6qZAdsLheKQ05qAU
PjE6sdBUp2gWRjwg4GC4+3KrtssRLwc4HI8UwrykMWASCy3sK6sWYrYNB1OkaBk7YqgNR0ukkLrL
YLAcLRU9awe9yHM5miJFs1B0uRyPR8rmWFvDFMVCA/vKQaHEMQmDjccjZUu7lrETRrFxNJ0pSvHY
/BrpK1rOFKduCh6VcDTdEmtHQMZrEo6WSHFKFRDls3ucTOxLy9jyvT1OlkjJ2pmSodzmZIoULfQy
5GmcTBW9lrGzMNhkuiXWHDtjBj8nS0UftQRb8PiRkyFSvFaAt4QtFh6PlMaxtdArGCPCyXSmaGtY
IDjhZIkU1hy7QH3E2XKmbFroFbww4mypU1aNY1dokThb6pRN2+XqxUIL+9KunWOFPo2zIVLcWTtT
KqSKnC0V/a5l7JrFQkOkVPWQqtCfcD4eKa2s0NhXxQcZOBv6KaQeAeTEQtOZol2zkDDYYokUp/kh
YaYMF1M/RcuHhDcdXCyR4jQ/JGGwxdRP0XaZ8NyMi+VM8Vr6Irwz42Kq6DXHZmGwhh59Sw6ahTKx
gQ09+namaLsso4XZ1KPftUiRmcJs6dGXXYsU+fgdG3r0bQ01fihfvWNDj35LJ+1Mkc/dsaVHj67O
CDDJd+7Y0KNvp57yk5PDgCG29OjrplCR5DCxk009+l0FFAZr6tHvCuFstSPSl6lHvyscOzl8TIot
PfpF32VhsJYe/RKUczl5YbCWHv0SNLfxePvFhh59A1SSQ/LCYA09+gaoJIfkhcEaevQNUDlGk4dy
mi09+iUoCTZ5YbCGHn0DVI7RFITBGnr0rfBRjtEUIKpnQ4++ASqHVArCYA09+gaoJNgUhMEaevQN
ULm3SQGPbtjQo2+AWvoKwmBNPfqopa8gDNbUo49a+orCYE09+qhcEaQI+TT3Hn0fOfgK8Pv29O3n
/vHT0/YNcI08y2yGU+LRjJUUhb/2Dn2fLKfB+esoz7FaPMnoBO79+T7wbAT3t/5j483HVUkmJnDv
zrekGN/CPX75uvX3Y58/PP7x5bxdUK9PtryCKgS2t+gxo+MmKnUR/9r4TUrDZyRJpiVw79N3qfdb
1D9Oy/enN3uT8F1j/DNCxFzflkMcEPNNxHQbsU/07e9Fmjc2wvsK8cfX8/K0Pf7xcW1/50ne4pLj
m0MiEob5NsgASH8Tkm47Eb471yAjIMNtK9NtyM5mezoGZLxt5c2HEQlfm2uQGZDptpUHIFmsxBlT
nl9syZONjvd4+vLjc9vx75eIDLd/ee6K6oaJY+blxaSCedvO3Hltw8RJ8xJAI0ycgjcxo9iJw6b6
23bKwKugYmbYKf37Gg5gtt8ebthZYCda+P7lAdTy+WN/OdofLV3X8baj585tGxZiJ7oxVjywz11T
3bAQNNErWLfXDbMN+hftgRUUrNvrVQLyg8/zUk6JiDw07CelnJIReWjZT0o5pYiVNC/lFBIreV7K
KQx3RuO+f6f17VZvBqepHs6Mjn18eUz7C9Jtl6n9Br8h9bAobx7Twve+nn58207bx39fD+d0+2fW
XgE1yB4d/U3z2yP/Y88B3358fbrmq8U99Nvi5g9DElEz4g3deg5/JhG/InYfPOk2VrERY9MCvUK8
JKxfQF/S/2hWeaokZmKGU3Q3QdOVNPbtHoGSE0sxwCn6I6DuNqgXSzG9KcYDoJJhQ9yHI/kSRu82
UJwqF1L2+PF7o0z/83dYdNNzMHGgsXhMjCivF7DZ8+3r9vmMYOtXM7d/YkawoVXv6c1MhA/dabpd
h7Eqwg1d+v5BmwFWdSndxiIEHBr0fdjgAKsd+Nf1Gg7VTiy+gd68fzuM7O1vPMAzMH2gYb28Dh7Y
dTpgV0A6RkfekgHSMAPwxTPqtAzAWWyUDy6/jqt/fvz0SYv/MWQVIzFPhYIG+dtRSIIXJxk7nW5Y
+TqhjCCzcyBq6eWLQZqVxyC9WIkJR1RvWnmbrvUP5ABS5t7STSuPQCZEHvrz+cL4xa//91h+6l9h
AAJOjTcv6Ie5ON1Km33UPEDl1Kg66G/H4qXP0wZoPQx62xn70GCAYqDES9nwtHz/56fOOQ6m+T5k
FTio3t9wjpZpnr7vrX4UTpUPYEV4c0bdXmmMleAgadlOo4o9e3GQ3onv78rus6vAf9GEn0KC+jwl
IMZZKbBPnAFimkiCcnBiZp5IgvogA4CWiSSov/kGaJ1IgvrzWIDSzBQRiljK9hQx9qdAsBTteWuK
GO8+I0VIi/7FpZ5TxNFMGx1SRO/M+1eTea7jOQ7DyOVJ78ebLnCTp4ev//g/9xoqIjmUZLy8fQ9K
fKRk48Xte1BF1rtM+IFyx9b77nf/QJZlp/t/YHKy7M31feTy2hEen36+f+bQO56QJINIi929/nUo
mJ9+/uvH9kNGtXi5QvPOn2Sm2bt4kjykw+5YxxMqT60UX4Z44hPSYH9zz/ILnuMrBSfl94pjSH/d
k2qfv6xf+48wxCMQCmmvx6L/3pOsn8vb2D5JFOiut6NN/b1Lept43sPLkjDQXHfxT97bPOVf75yQ
F9To9iFqAKNHh93FegiVbqPKnRra7P17xEdQ357m76LKtVrvtWM6858j5b2c+f/sXWlvG0eT9uf8
it5PkYHY7vsQoMUqPvIKPmEr610EL4jhHDJhilRIykd+/VtVPZQ4wxlyhsNkX2BDJLZEdz9T3VPV
Rz3VXY040emKFPsgiysdrpFZ32txdN8UDFHcteJFp2sk1vdanN5rcVaQxUVefa/F6b0WVzpfI62+
1+L0Xouzmiwusup7LS72Hx+n7fKZKJ89ksWVPlfvjmpxpduViPXjWZwNUdZwVItzgmRFin2QxTlJ
FofM+iCLc5osLhLqey0Oew26LG3vtdLtGvn0vRbn91pc6XSNR973Wpzfa3GlvzWeeN9rcX6vxXlO
FhcPvO+1OL/3ffjoUqPz7sewOB/dasEf1eJKpyudeT+exXlyrwk6+H48i/PkYRPIqQ+yOE9uNYFE
+iCLC3hhH+CoThaH7XPFLosL5JcX8aj7XotL91pcwMtOAM90srh0r8UFHeWznSwu3WtxgRxqIhLm
ey0u3f8+yJcmiCw/hsUFH7U4HNPiLOekxUSVH83iLCevmiCy/GgWZ7HViCqHWZzlmiyOKHN3773q
YWyWW1JmEW+53nwZN7fwase38aZW0l8RhBSFb8eKihKvnb931fdqUdSNeJR9N93F2fJrcnOTLzaq
izh0xKvju3JdjUBxzIjcd1eiqxGI+DsRGe+uLFcjEM0ognjufRQX3j/QDoTXDwCQ6MNvNQLRykMQ
y72P3NotkSe9keoA1qgJjyJdAU8fQBk14onY9eYAvqgRj5amQt6nAetOFjXi4R1rePHFAUxRI16p
If4AmqgRr1SUsJ8jaqxOuxeheFeGpBEkUJuU6EOPNAEp2uEKpK07cSOFzUQzEG1tBXLW3YmRRiDy
fIgeh8l9oih+sxHNxN4+LIijEZF8H0IdFsHRiOhJ4dVh4RuNiKV6HBa70YSoKZpIqHAQZ9GISFFF
QnfnFjYJi0ZECioSxFr3ZysaEckfIuKB8i5URSMIOUEE0tSdNxINRIXVUU3i2fGe7ulGPAo1E/Ho
eE/3dBOeiSoST473dE834pUK4g5wTzfilerhD3BPN+KR60PQsfG+G4lGvDivGH7wRqIRlRwggo6O
H7aRaEK1PMoqD95INKKSM0Qgfd15I9GIQ04QgaT1IIuzcSUSj4z3dE834sWVSDwx3tM93YhHMWci
Hhjv6Z5uxCt1xR/gnm7Cc6WWhAPc0414UT+Ijj6Gxbm4m7HiqBbndJRSHtXiXHSD0LHx41mci84y
ZKwHWZyLzjKkqwdZnI873nhSvKd7uhFPkMXFg+I93dONeNFZFs+J93RPN+JFZ1k8Jt7TPd2IF7Uk
Utg93dONeNEHQhT2MSzOR4eIk0e1uBCdZURkH8/iQnSWEZ19PIsL0VmGpPYgiwsUiCaQzB5kcSF6
zOIB8Z7u6UY8CkET8Xx4T/d0I16IGh0OcE834DlOAYoing7v6Z5uxItaEinsnu7pRryoH0RhH8Hi
XOlU9eqYFue4pZUREdlHszjHXZTVHNPiHA9RVjvM4pygqEURD4gfcnbBCTruKYi47ujPbccq9YQC
ySuZF2tYd35P2Y4VdYTOgXd0D7djUVCrCN39sTvkwh3R2dkZS29X7FO+yNkJtOshfrVRihK2VEst
8VzSVjkMd8IHouNNmUbJPnaUjA6b8nhwV5HVH95KOmXK44nd45wycHTIlMcTu8c5ZeDojCmPJ3aP
c8rAGQyX5PHE7nFOGTiDusDjid3jnDJw6OLFQu5opwycwbBaHs/rHnTKwJlSZw4+RwXDD3W+6HGO
qh1LUq/H5NgDxyKrqLvjGdyBY5HFS5h4eQZ34FhEKbT3jEXWY9A9g9afUozqKXuRTKZ5xlZztlzN
b9jl/7Bnr89/YjSHL8/4NxDuP3548Pen8ZPl49urUUFdOFrNR9iFmLc5u06eXIon5TsSj6fzq4Of
gS/dag1/W4yHfYBjISwSHkR1gO22sQ+EFELgJSD4PbxoIx8wfsR2tn5ucR5j7EExnSTzHeWeza+T
yYz9uswXy79Crr/oIxTSxAKH3uADbBpP2SKZZfPrU3a5+D6ZXaFdLfIkYzkMM/Ob76xYzK/Zkyz/
8uQ2lvyhiqGkPmVP6YDAbUx1zQrQrlN2p0u4KqxVMjqcsjy5mU9HX6CDodKZvC/iH2sfvBKnbDb1
oB3wA00JRZLmOBII+BUHgxi0XqtmLTSpwHkExEpms/mKzWG4ZO9fvLx49YqBMNCuKYMGTdK8Xtmp
jWeWNaAVq9slQ6DkCxgO0h6VeoHLYDfq/brEfswWE2jao3GyhMFqXhSP0k8gTT6FAatWWwleqZ2z
ZX6TQF/m7J18x64W89ubjQ44icgsyeDP1QThl7c3N3NYnW0Buw3gy2evPqxL5lm9qJT1ovk3eOIs
mTLKZV4rb/lmi88zaOLX2YaQk2Iyy/JvTPJ6RRE6VRSqWhFGi8138yFfMby7ZqM8/Lj6fpMzxU7O
39W6Qkiz2cdPQcOhdzefSlUtO3n99s3F5dv3tfqyqo1v8q8bla/ns8eklSnBZqdroc6MrcMY3an1
1YqGKytFtSKq2JZRgO2OF5PsKmc5fPEo/lxF0tJBT/z84QOje0GY+Al/uXjGrpPlZ5ixT6v/sRPO
xpPVstIfRljYcm5aSn51O01W88V3EKKYL67jOPAoPmPx/ezpm3p9s6maEpYLj6T2kv0XrBzY63/8
US/uNtXTOGUeGa9MW3GhXbW3wEbgl8dCjKPWlFY5K7+92hS7joVjwtP59c00X1U7fTKbrCbJdPJH
YzUPHfQannXKLp4/f373IPY0DgOnzDP2YpHDsmWWfscu0K6pJUHWtL6AOrH0yadVycJmZwKsNB2V
Q8wIhhsw2jNef2uag/q9P798/hssqXCAOROcFdPkCtdNol5Y2LKwKAvLHYXlGlmWhY1pL4zGRIXV
WoxdcqhQltZlaXtfmNcL67XQpiwcdhQ2qixs13LIHaXtWmq3Lu13lfZlab/uPb2jtDNl6VCWVrsa
6ddyi/V71LtE8esOFOs3aXbIYlDlXkxvl59Q3efTjGZAtGdcEkzyZa289fDqn+XJ7eoTFJikOLIm
0+m6Vr24FwD/9SYZxWlsVCo3uaM+59/vB08Y0ZPp1RlnGKNydjKbTB8yKDCaZN/gy+i9oh9+H03z
GfyE/0g/1Z4YcOYY+kTR44mOKzP8ibLPE+G34U9UfZ4oUaviUqc2D32drD6xT1/xATihBH7qitOg
T212yqHIDBRqOcnYj+fvfn7/9s3zy3+IH2vYintUKWgKwn98d87efXh5P2jfJMvlzacF/FqvJ6Ae
zWaPYD/5Lbu9vhkly3QyOcEWCP7w9AeGHy2Y4UxLZiTTBdM504YZzbRnSrCmz72s8ff6g6GRJOPJ
+YenFxcbEj7cI4pzzBpmU/zPKWYts4I5ySx8XzSK8jWfTpdFsriab4viHMzvthSFVu6NkpAMSj48
ZcoxmbE0Y4lgIWMqwady6Bj40rHUMJWywjLvGAeBxixIElcw6VBKnbGQshwkHjMlWcGxI8eOZQmT
imW2KltwVt3vN36BBbXkT2DEHX9f5ctdGw2o7L0TMM788vplUzOcZ14zn+GbhY4scgbDfh5YplAO
I+jPAv9JFNRCzTh0dsKEZM4ylTPpWT5mPOA/aYDKsZHwNvwYKm5K4sG4PZj3y/w7LAvoarUmiYJi
asyylHl6yLhgHkSA5+SIDY0GdQOJxilTnKVj6rQx9pvj2JkYIgN9brH/fcGCwYow58PaJU1ZqmsS
WQMSgZ2g1UyT7+WeAUdgWJ4mKYzkOSMHLgOBJ1P2c56kuFFbJNfQ85+SL7AkymGTlJb7uOr+AB7g
cFKI1p5/myxpJbTeSt2bfzZZ5CkuAx/XqgcXasuYcZTgJP492l6ueI4ZYcpWfSDZm1qFbiCAK9di
OFot6yjWlShN9XMUHlsTv/7l8uXoAnYA7OS/X52/eQQjSU0qwZUGJYZyTW8dbCnPUesyjStTGE9y
w5I4wih8u8EyXrBcksEo/H5MpiItSwIqgQtMBYbx0AnpbYHKiWe0UxZCTRLNffeWfXh++fL5/354
BqNYe+Oc86LXPCLjPAKrNs5NkmZ+e8IUDZOJkrXnegmdCp/xYp5keO0nFq2W8Vy0z6p4oym185Td
/cj4o/8U7OTXdw/rQLR5yVfTyezzKXt7XxW/wP3B2SPYFt3hnNlafYN6iVMdqTJ0/LzYNIL5LH9c
q2FxN/D+8vXozfOPry7evNyQEvoH+nR0t/rF+NOTusROb27/Lq5m80VeeSTsIvMv8MYZmGiab+0M
l6y6g0dI2wAZMWArhP/nk6vZ/Y5U1+s7vV0/g7kJ+rAXjrd95BBb9YMb1LVe+mN3rccRYohIFTdU
H5HuXBGNYvnOPQVji2Inv/367p+/vf/1zZuLN7/887dXbz8+fz+Cr+riBi4quD+xixevzkcXL96c
v34O8t9J9+NavB9x1KjNMYiDK8rZ59l9+0y9iBSDejZU3EBHednBmu4ilZ26JRau2Tr1YGvvBWjv
pr+0GC3y6/kXWDAnU/TnfmfpNE9gYodpa7JhZHUUYYe2JnB5hNaYo7TG1fxAG35JGl12e8sQwdcR
uvg5oaLQDZrWfVgLwjSMATuGVVevj2o5pL4bNCwHGG6G1Q/+zxisgsRBZqByysq7PVQ5pa270Psq
p3TmMOWkvfuf0blheOcqaY/QuQr9gNdX16vT04xcU7DHuiuixWNQg2BB2A+AAdsGYVh53y7igpTX
kxldkF+pgycURUffWCwvcDndxTcWiysriUtr21YRCZVf36y+g5TQDeQemeBmCuTJamDG64qLHntx
Wzk2OQqop2E95fetjnnz4piqw1xmTjvxNDA9f7g8v7x4++bhD7tg4YVKeF1S94f9v2Zb//0+3fh/
+Wfy/3jByQb/ryL/7/7m//+KT4WGhxHCDuX/TcD91w7+Xzbw/1bidn8n/y+1qcwDmwtx2c7/S42e
2AP5f6i86abqyv97TFt/MP/vZagw20fj/xF4szk7+H+P6XP78P/C20qkRH41WaIjlByK0MfX1+jm
j8MMO8Fx+Uxy/xDeTL46eySEZidvYw4aUJf1xI4vdTG/WuTLZZ2+95XVZO1x18kq/VTzxgl4Frd1
lMrrvY8jW6zxztOovwQLsqQgCr7Lu6UGLstge1pj9ckx1SWmobLINVxbzndOaro9psFwqyqek54x
DUZIXfEANcY0yIaYBleH8d0iOuoVYaGnhkciwBxiq6rRLxJBObmpyfsiEZRTm4ayLxJBuVCL2zg8
EkF5VLPekQjKY2jP4EgE5bfibwZEIkAvh86RCBpWCZ0jETRHF0/HSARNYShdIxE0rGo6RyJoClnp
GIkAhUP3SATNve0eiaB50N0jEeBv0T0SAf72PSIRtLgPKekQiQBrRtsnEkEr3Nt3jkTQGue8TlyH
Pk4kAixp+PAn9olE0NZ25XN2PLFPJIImjnfoE/tEImivZWMkgqxGIshdkQi/3ObLVS0MQQcE7h+G
oAP67lrDEFwtCsExZ5BUd4o53cj4b0QhkJx3v1efazh6x/tEIai1KFYS3Z0jxW+LMgrBZiQW/FNg
VuE3G59xMvs8L2CdtAA7q0cheOXQC9A5CiFXGEPANQuBGeiGBLlwGViRIWWeG/wvcyzkyNqnAWXK
AxMeaVOdslTg5OvH+P3YMZ6xsUG63WsUeiyqsmmOg9ZhUQigETibtkQhSAqmkKDXHAX1ROyDBIln
1iPRmyoMl0glMyl+4zxLJOMpxqAkFLtQ5Njl0BIP/5Sygup6gW1WWVWSQEGO+6IQArLMPiFy2WJ/
hhjbAVJAJwP8GLtaFEwIpJvHKUsSZiiaQip4JoZ0gDVpi99zyWB2TAoMExlL6PmaRORb/dOiEPAB
6BQ+MAoBqusDohAEzONicBQCoKhwzCgEZzBovCUKQSSscBRdkqGF5PDrGKMKdEDTkmOMRQAzKxLU
UtCAYNG64K0XFm0MVEQnaEsioIoYhzYGf2YFxf5UArO9hF3IkaMQpAqq38x8nCgEGcNUdkYhSC1s
e6RdjygEAELf8MFRCLB7C4aiEGS3KIRguapsRvZzMqpWX4tenE6V6sf6qoET6xsygDi0HziQBYb6
pnLYoScLLLdZYITsSffVu9aYhmiKHV1i6/V70n1b9XvSfVvyV3jSA+qHfnRhvb5Vsp3vKYuYzqRX
o9bYJhGHaQ2FNA4QyemGt94nUKRFLNs5yqI7PYi4TvULFJENFCHieLkzUASLhO4hOFstqMvteVe5
22X2cnPtcRCtiSi6c7BJrzfjTY+QjbYWenWMFg4cCII4dCAm1lRy0zBH7p+jtnF8v/gNW68fGky7
w1xZxzEYpteP5Zbklu7KcmsfAu94AgSLBy7ksVhuBLMVyqaV5Xab9Zz2tFc+iOVWjxX8XVHTHZ77
fzM6eif/K58c5RnI8jpjWvhf+tzxv87JB1w4KdUDZo7y9D2f/+f87573n8FG/GqU3i4WAyIAdvL/
will1D3/j3oiJWyy/+b//4rPZJTCxhyv7cWU5VfxgpUAu0kG+2arecaZAmOsXNbh9GMfYKmJVzUp
TAMghOGbF39g/vNmWM9g2cyV96IVlm5oVZgRAGBNN9iUcZPnic10K6yP0uIFVXh9UgfYXHDm8tTr
TOZtsIZHaR3BdpSWM8ltAtNeO6yI0nqC9Z1gQdoMbwDjorVvDSXzVZhZQAi6Fn0/LF6DLdJciJC2
wtI1eYryDGCuos2raSar0e/zZZmuUNAVMLAyS5JWLLoqT1GqAWfcDqx4BRCUbNVQQxcrKso24Kxs
x+Lrq2mMbMWiSxVVTDhgdTtWvr6aqCjasCxdpahisgFr2rEKzory04pFKZ9VTDRgd/R9ofdjRfWI
SQbsjr4v/H4sunRTxQQD1u/ASvdjlTqB1sBr1ygB1tV0Pk6m6G/DpeuS8ll6pEuFL7j2olVvrYsy
ojnwsCXjFu57vF5wHK99UrnyrbiUz1dh9gG8NLsLLlhtymBAwOuRxm24ji7HU5iQQHBev2ZwOSmW
o9Xken0P4vr+emFbDcTJKCgmleGidhfgcjpfbcC5NZxv7U+nyN4wPQFGutbkS9LPJN78dhVfEYdF
MUf2ZczbJcTbpQARJxku6+mb09XyAEgbpaQJpnJvf/Pb+djxrTsfRaUZRu3Xptdd33qI8uIUE9Rm
F9BllSUQ12wMsyqsq1qHME+pOZWiSSXU1YfSPcRMsNRWCftn0wpF+TgVZirAhVs71EZS2TYoRQMY
pigAKNsEFcf7Ekq2v1lvaPzC3AQAFVqlEne3mrXOlJ4yPStNeY+3knxvQ4kdUFEvNOUmU3UVXnwb
jW+L5eSP8rpRbks7AxFaEaNGYJICIVVjO7HLlF5DtXdZiDpB+QmM3boJFXYCMdpxhJRNmdZJYVon
qzzfARv1g9IUGLt1AWwzrCbY1O+AVVFaMgXNt02B7hv0d6+31VaDUQTkCUg12hS/u2UQ5842IEtL
H8xPAEBbN/tuALlsNxBlAVeUmMDIypV8NHyMxzRPJNKsr5gP7a2jDK2K0hHgkq8J6yNi3aePbtNe
GKFIeykJQdB+CytNptTIxNJN4R4VuG1x5znlr1GGFlHVGz1hyzn5HdFGi9tZbKo2G7cPtiFGjTC0
lNJyB2KUke9vMCWzUZSPQPhNHfuaTFZRsk44lMJGUR6CQTiUvldR/oFBOHHQMH4gjogjBuUbGIRD
KeGV5UNxKB+8ovwCg3Ao8beycihOXF5QDoFBOJQGXmHWgGE4IfbzUH2WPPbzUH2Wcc1ph+qzjItN
O1SfpY79PFSfJd3JrNxQfZZxU+KG6rOkO92VG6rPKm5W3VB9VnGj6obqs4qbVDdUn1XcoLqh+qxs
7Oeh+qxc7Oeh+qx87Oeh+qwpS4jyQ/VZUz4Z5Yfqs6Z8Q8oP1WdN+YaU/xdt17Isx41jf+V+Ap8g
uJ2IWfamN1513MisyvQoxpYUktzjz58kTtV92JcoQsn2UpZOoJgAeAAckmf9Ock7Q5HP+vOt38mD
/txlQomxzs2f6/ve3itR+wvr64NVLHYRsDgE1v2FWd7CjHIjf+WOZcJt8TxR5uu1x22PEk/cW67k
HwWrXTB5qD3KnfxdsF9GweAQVXP0IRw4RNUcfQgHDlE1Rx/CgS9UzdFHcMhL4FXN0YdwAtZZS9xD
OAnrrCXuIZyMddYS9xAOYZ21xD2EI08YJqcl7iEced8yubP+XOT10+TO+nOR4jG5s/5cpGRM7qw/
l4x1PuvPhbDOZ/25MNb5rD+j35jcWX9GuzG5s/7MUigmf9afWQrF5M/6M0uhmPxZf2YpFJM/688s
hWLyZ/2ZK9b5rD9Xh3U+6881YJ3P+nONWOez/lwT1vmsP1d51imFs/5ci6xzOOvPVaZVKZz054pH
v1I46c8Vj32lcNKfq4tY55P+XF3COp/053bTveCc9OcjvLDOA/58VXEY6zzgzyqOd7LOccCfdRx5
RjLFAX/WceT5yBQH/FnHkSdGUxzwZx0nyzrHAX/WcQrWecCfdRzGOg/4s4oTnBOcAX/WcaQ8TPGs
P4eAdT7rz0EaBCmd9ecg+qiUzvpzKLLO6aw/B5Z1Tmf9OciT5imd9ecoT5mndNafY8A6n/XnKPVg
Smf9OUo9mNJZf46EdT7rzxH1YD7rzxH1YD7rzwn1YD7rzwn1YD7rzwn1YD7rzwn1oDo4HMJBPagO
DodwUA+qg8MhHNSD6uBwBCejHlQHh0M4qAfVweEQDupBdXA4hIN6UB0cDuGgHlQHh0M4qAfVweEb
nF6ntWbUgzI4LKV8PFr/evyz53Yx0q1RLY8NH7lvdT2VWDuSI7h4PjLPwxXNSZLBYnn/EOGHuE0Q
EMvDxvpRrsHe5v/s4oi9tcnP9pKW1XXFEJUy7K2Ca7a3+93QR0wyiGTfkUR8YK+g0rWnwqwk/eQk
g8mZ61vAI2VQOb6+h//6nde0li6uh71x8vqWCHuTaX2h2vEb99cB9YYMNqeuL8FeMq0vP22Xfav7
3tOoN22m4JbZ64t+hAxCx9cXUqH9UnpjqKbIEdw6Oe8w+lQyKJ353TiKvTI4Hf9ul6c9pX137trF
xX7FYfJ3Y/AWGayOf7f7Y/K5m3dYBFBJBq1T1xd8Vgavw+vrRZFfXXbduKioa5gmr28NsLdY1tcD
N7i1u741wV6evL41S/3C1bS+6cm7fdv2vaeHbgm44crQdur6inAiyfx2fH2R1/f18rHsurb/C3vD
zLzTcD3sjTO/W8NF31TmvePfjZ/2kK4Xp9iL/nnNM79bwyXhUTIPHv9uN2kpbx/HRcMFj65T+WTD
rbDXxCd9e8NqP2J1+5hP1iZBh71T+WTDlTo7OxOfvJ3O8vulu74+OcGdyier3CctuCY+Gdopt30/
ds7++hbYO5VPNlw5mZidiU8Gd8s7127eCXI0Mct8embeCR720uTvFiLsLabvlp72mJq0vo+bYC9P
/m6BYG81fbe7er9z2q3higA0+6l8suHWILgmPtkO7Pq9XlKnT9AQZN6b/VQ+2RAC7DXxycC3vNM5
9NYQIuydyicbQoa9Jj4Zjrx+3fes5J1IsHcqn2wI0hfO3sQnb0dijrzzcZ3VEGQ+kGXePjPvJA97
6+TvlkRRmIOzfLd41AF05NZ24LCHK3OkHPzk75ZknphlXj/83e6HQSt3804SAXIOs/lkYthr4pPt
4GDY65r765sd7J3NJ7OHvSY+eTvoGHr3JTTcCHtn88ksR2RzMPHJyE/+IDu07/11kH50DrP5ZJbz
kDma+GS89XdW7vKdLHOKLPqBmXmHPOwNk78bgVfHaPpu7Q7YfCXnPz4d2nDBq2Oa/N1I5tlZ9Afj
3+3W31k6feWGK3rnHGfzSQKvjiY+2S4f33amvHXzTgGvjrP5ZBH9S44mPnk7GHBw0e76Fjkwk9Ns
PllEF5WTiU+m9ES8bwfl+Xh+1XAJ9s7mk6XAXhOfTLf+zrJ3804BrxY9xLQ5WXXy2xuuoX5bh3Bl
fprT7HjDQf6cDPHW5mNPYScKRzbs4mbYOzvemGCvId6W+5zM+9RfB/DqPDveWM5h5GyIt6XNnaLf
r0eS7fpDFf1VzrPjrQbYa4i35T4ni37trkM7Zt9wZ9dvFbw6G+q3pc2d2gsx196crOGCV+fZ9VuV
A545G+q35WVOduzMHVwPHW/OhvptJO/4gxwL7uT6zTvRd2cy1G+LmEl0ZUf9dQCvpsn1m3fg1WSo
35b7nMyH0l8H0ftkmly/eSe3SWQy1G9LmzvFtF9X2j6eQx643sPeyfWb9wH2Guq35T4na27UxU2w
d3L95j14tUVfsrS5U95dXDXcIrxkrr6k4Yp+OFv0JcvLnKzmbrwFOXCci6F+G8o7Aby6TK7ffACv
Lob6bWlzpxhoKUreCeDVZXL9doSF8JJiqN+W+5zMhy7fOVKS8KgymU/6UGGviU+2y97SvlVae/WF
j+DVZTKf9BG8upj45P0Ww7h01yGK/izP1Zc0XNGfZYu+ZGlzp5Rccr3b+houwd7JfNJHhr0mPnmf
k9WlG28RvBr6kol5J4FX81Q9V8MV/Vlmg55raXOn6I/K2+XufpxEf5Z5qp6r4RLsNei5lvucrF09
3sUtsHc2n0zg1dXEJ8Px892+rbR0804Gr66z+WQW/VmuJj55m5O1e/e6uKI/y7P1JR566WzRlyxt
7nSQnZZ3uv6bCfbO5pMZvNqiL1le5mS1dvNOFv1Zhr5kYt4h0Z/lOlXP1XAD7DXouZY2dzoo6PXi
qDff9CT6M3JT9VwNV+7jIGfQcy33OZmP/bxDBfbO5pMk+jNyJj4Zj7we9+1Ke28e4Ivoz8jN5pPF
w14Tn7zNybQ6q0TYO5tPlgR7TXwy8tPhmSnuezfeiujPaLa+xBfRn5FFX7K8zMlqv74ooj8j6Esm
5h3c90B+sp7L465Z8gY919LmTjGV7fjaXZ7KEfZO1nN5Fv0ZeYOea7nPyTz16wAW/Rn52XySGfaa
+GSjDbxfL+w+Pn/RTvE72DubT1YPe0188jYni9d+/6xG2DubT1bRn5FFX7K0udPWpB79+byvoj+j
2foSXwvsNfHJ+5ys7N28g3smCPqSeXOy4BzsNdRvlyHcAHsnx1twoj+jYIi3tc2dPNF2/POe7io4
0Z9RmBxvwRHsNcTb+nKebOnqMgMutqUwOd6CE15N0RBva5s77dtOCo8KXng1xcnxFrzozyga4m19
mZPlrr46eNGfUZxcvwWfYa+hflvb3InSftl75zoaboG9k+u34MGro6F+WwfmZCGI/oyioX4byjtB
9GcUJ9dvxx/CXkP9tjYz/VaOYPK9ujvgAl1Kk+u3EMCrk6F+W1/Ok12UdQCvTpPrtxBEf0bJUL+t
MncKe1lK6emNQhT9GaXJ9VuIAfYa6rf1ZU5WL911iAn2Tq7fAu7VIIu+ZG1zpyXsm1PyTgSvnq0v
CRG82qIvWV/nZL6bd5Lozygb6rehvJPkXAflyfVbSBH2Guq3tc2d/F7CxXVe72m44NV5cv0WEnh1
NtRv68t5sku3rxESeHWezSeT6M8om/hkmzv5nY+009NdhSznOijP5pM5wF4Tn7zPybjPJ3GfB83W
l4QMXm3Rl6xt7sS0b7mvCwoZvHq2viRk0Z+RRV+yvs7JYjfvZDnXQdCXTMw7uBeYaLKeKxB4NRn0
XGubOx1E1C+uq6c9aAnsnaznCiT6MyKDnmt9OU+m5B0S/RnRbD5JDHtNfFLmTnu7y66LW8Cry2w+
WcCri4lP3udkpfbtBa+erS8JePqMLPqStc2d2O8b9+dkAe+f0Wx9ScD7Z2TRl6yvczLXzTu4j5iK
4b6gobzD4NVlsp4rMHh1Mei51jZ3CmuhiwvdOoBFf0Zlsp4rsOjPiA16rvXlPNm1XwewnOsgns0n
mWGviU+2uRO1vNO5f+fAreDVPJtPVvBqNvHJ+5ys7n17watn60tCFf0ZWfQla5s7LQffufR1QaHK
uQ6arS8JuAeZLPqS9WVOxls371TwajbcFzSSd6IDr66T9VzRif6MqkHPtba5ky8pLf06Kzo510F1
sp4rugx7DXqu9eU8GXf5Q8TDa1Qn88nowKuriU+2uVPeV065l9ejA6+uk/lk9KI/o2rik/fzZL6b
J6OXcx00W18SfYK9Jj6Z0pO/7rsyn4+4f7nM1pdEL7y6WPQl68ucbF16dXf0oj8roi+h94/SCG6D
/e3Lcn1e/v3rc3j+unz/vn0fHpfFIDK0IjKT4v6e1jrw8nxivnX/+lk+4nm3ImqT4qoZvk0INHgp
8gsuNbFan+7W97hxDJKTCrQnVuvT3fo+PMEVy89Yz4+tZ3gk/4z1LNZr8NHBMet/xjGj8KQCXYpp
cdYXx9xK33qR6xfIU0yLA/i97kWDF3VREZWK2fr02HoR7xcff8b6JNar8DITKbgTxWo9363vtdjb
o08Cn3/G+uaYF7cr8LhRuoiC5T/gmCnAMe1Re3l1zO78od3sLvD2qAX8kXFU+AzHrD9j/T1jdk+P
RtwaUoL7GeubY163XYOXJlMJ/mesvztmnxtAk11C+Bnrm2Ou267BYzOE5EVeER+Fr4dDPq1HQnfr
2usgR3S8C5Qv4e8MRIO/Xp7CA0KGxncRAUwTl7yB/779+ONrIzif1m/Lj09fPt9Q2/g1VbdoqASj
SVDjA1Q8vvfgHeiGyrC1CGodt9WrtlbYKs+E//11dDHP7+7lkfteLdlUkQJ0BGFb9Q+B2o14d6Dc
BZLmUhFxS3tx9hWofejPO64t2I5qzl9jaDd3dZFE/lhEzhIof4D0yzuk2BNwR1xkXUTA0rVpEaTL
dvxKxSYp3YpIVro2vUEKXRJN8AcRqXRtWodskuOvRWQpXZveIIWegKhRG0Fqnn/80QdI//jX69Xs
rnc1e0MKWPEiSHQGKWLFWZDKY6SuF+A5vCLyksAf2fTPUZuQIURQclRDmo/Xq+qZeBKviIQkho+8
4Jd3SH0vQBO6iGikaxM8s3rVMyGTLiIT6dr0BqlvEy7yKCIM6doEz6xR9Uw8jVdECtK16Q2SYhP2
DBF/hPA2Wo6/+e3H8+f90t5UfetU3TcIGpyc6Smi+Wjv+5yFu/mDeHtMg3Bd9+KbUxwu75sq482m
s67P/7f8uPzP9cuvz5cvn/dPv8JDysBeVpEnmsDjgE2PYH95D9vtM1XQ2KbvkDOEQ7CpXXe9t0tY
urAJ1rbIaC3IN7Df/nzePi/rb9ttf3MDv11EPkVEHe0CvdcvtFyv3/5c/9ift+vvyw2wpCfPdSmu
e4ot1gLz0jBgpZo1QBTZIuMYtHAJrAHK+dMi+o1RCzP1AQ9PhIVlHND7oAHKJL2IYmMYMGqAMkIv
ItUYAzyI9kUDRJEjGo1BC93VaYByyKuIOGMQMLU3ZfuAcmtCEVXGqIWL4jbJO1g4Him1bF4DRP+F
xiNFHu9QAGVAVcgSKV79yQkWWiJl1/zQEywcj5TDD9U1lDPJhcYj5UhfVw0QzWBCpORHgHwAslsV
wFv7tzgDYFEBRVZRircAarEMnXIpwQKorSEEyqVEC+CmAaIZV5IFcNcA5QqNUvIwYG0KZwWwwkIy
AF619IVLnkspFkBlG01RVIClsAVQ2/VwrXMp45FyAGrpC/c5Fx6PlANQS18RZJbHI+UArBog6CyP
R8qWrpofRtS6PB4pla4ac0igsjweKQeglrHx6F/h8UjZ2kVpCiDoKxsihbIKCAbL45FyZGwtHyYM
jdgQKe2iDwUQDJYNe0rV1xAMto5HyuZWbU/JIgkt1bKnBM1tMhhsHY+Ug85pHyWDwVZDpJSLCii3
FZRqiBR3VdcQDLZa9pSraiEYbDXtKdq+TGCw1bKnrNoWQGCwdTxSNnfRMjaBwdbxSDn4obankDBY
duORcgBq+zLJ5TrsDJFSF81tSBgsOwP7qovmNlRhoYV9OS2WoQ9mZ2BfS9DIEoTB7AyRQruWYKEI
ZjceKUfho1qYYKEhUnLU6pQiDJadYU8p6kZfhMGyM7CvgxFrgMJg2RvqlMVr2QbXKbM3sC9iLZZZ
GCx7w57itFZVQheW/XikbE33rwBmWGjZUxbto6Ady97CvtSvjIYs+/FI2ZyabbjCQgv7StoaohnL
fjhSjk2UtdCrwmDZWyp60tgXGrAcLBV90koz9GA5mCJF+yhVGCwHU52ixTJ6sBwsewqpFlZYOB4p
W9KYQ0YPloMlUjblo2T0YDmY2JfSxMjowXIw7ClUlTXM6MFyMOwpXmv3ZfRgORj2FO+VSMnowXI0
VPTeLwogerAcLZGyKewrowfL0RApTgcUBsvRsqdUFRAMNg5HSsuHCoPN6MFyNLCvsmtfGT1YjpaK
fle/MhhstETKrmwBGT1YjqZIUZhDRg+WoyFSUtSSA3qwnAyRUjZtDdGD5TQeKUfho1QBGT1YTuOR
sq+k/mQw2GSJlF39KGCwydL72pVdL+PiYk4m9qVwm4weLCcD+0paQzKjB8vJwL4Wr+166MFysvS+
suY26MFystQpFy2W0YPlbIkUrXWf0YPlbNhTykXzQ6hjORvqlLJpfogeLGdTnaIxB/RgORvYl1vV
nwwGmy2RsqoWgsFmw55yuKEGCAabTRW9+pPBYPN4pPASNED0YDkb6pTFK12RjB4sk2WesmrZBj1Y
pvFIOciS5tjowTJZ2NeqJQf0YJkskbKpPxkMlgx7ilc/CsmhVyZDpCStEZTRg2Uy9L5aDaAAgsGS
IVKKNijMtx4sGSKFtf5hvvVgDTP6g9tohc+tB2uY0R+AmtvcerCGGf3OXlvDWw/WMKOvpE0e860H
a5jRHwxWBQSDtczoq9b7yrg+mA0z+gNQSw63HqxhRn8AaqF368EaZvQHoEaW8LIdG2b0B6AWyywq
AjbM6A9AjR/eerCGGf0BqDk2y6X3bJnRU9XWkOW2ezbM6I9I0fblWw/WNqPXsg3LvR1sm9Fr2Qay
WDbM6A9ArXi89WBNM3ptNpqr6OfZMKOvpM1Gc5XDFGya0WsdzlwzLDTN6LV8WOVoBRtm9JWclg+r
HIdnw4y+kqady7XCQlOXWHHsg9rAQtPkUck25OQFBDbM6DdVEXQkIklflhk9ecUPyYHBGmb0W9JU
puTkEhduM/rQHnx9Bfy+/fj25/7ptx/bN4Fjd7ub4ZJq705wcnJ3C7cJfSg5aXD+fpVnXy1OXk4k
c5vPH3C1B/eP9mPjw8NV5OVm8dqm8/Ja1ju45y9ft3Z+7POvz79/uW431PuRLa+gyr3itY3o2/N9
j1G5ifjXYw9KqXuMhHyCrUe0BP7rSv5+Wb7/ePdtji+83/7rIso9CbUN6kO7w/4RYnqMKGdDq0zq
vX/7y//4el1+bM+/f1qPf/MDZ3HZ1YeXRJBnGJkF0j+E5MdOhHt8q0zrvQ+PrUyPIeVpjCrzeu/j
YysfHoygIK9iVJnYt5s9Hlo5AJlgpewx9HJiC0c2Gt7z5csfn48v/v0WkWHglwuprRjbv56YVDAH
7BReWzG5fw2gHqZsWg8xhdpWDO+Lf2wnLrwKGiY0shXz+xIGMI/fHnQ70aKtMsL3rwegls+f2snR
dmjpvo6PHT0Kt60yvffR9bHi4+8chdZWGdy3GVMfa2Dd5EK6KjN7H4OCNbBecpFB9Twv5UR5L6XK
wH5SyknSya8ysp+UcpIcBqwytJ+UclKElWFeykkZVsrhxxL/8qk3g9MkOSRaZWIfXw/T/g3pscsk
6eBXGdXTu8O04ntfL3982y7bp3/fN+c08DOlh19lWN+eK3m/5X9qOeDbH19/3PPV4g5Lj13fly6J
yB5Gthip4a8k4u+IzQcvqo05wEa5Ni3wG8Rbwvob6Gv6771BQVk6+VVG9hzdQ9B0J43tc3dBpZtf
8aBD9COg7jGonAuseM0hxgFQZNgQ9+5Vq5QZlsquciNlz5++H5Tpv/4lFj30nCxt/IpHG+jtAh72
fPu6fb5KsB0/kR/+RFysW2VU33jTm5OZvzanaXYNY0npU2VK72voYRWX0mMsuciyyoDe19TDco7v
69W99Jno5huyd7y/jOz9bxzgGXRzidfTwR27LgN2yXynykTekgFSNwMQPENG8nMyQIF/JDy4/Dau
/vfTb79p8d+HlBlPxdsKHDTIf45CJliJa6fTAyvfJpQ+ZIaVry8GaVaOQcqkp8psvnB5aOUAXSsy
66l4R4H5oZUDkCzTnirz+Xxj/PDr/x7MT4wSGY8lvDtB383F6f/Zu97ntm0mnc/9K3Cf6sw0CX4T
0IxvLm3SvJ4kTiZ2LnfT6WgoinI0kSVXkpO4f/27u6BskgIlklJ7H66atHVc4OEC3AV28UC7e5dN
FyLkUClBJbtBP7S0FxcCZMNbg7ZQRkdUjydyXj2EDet09WWGPkfbZd5RrRtvKHqv+Byw0qxXE6sL
n8q0wKL6Nt5Q3J64ZixNCmK4aqxpYz1daPPIxAOWP0iukPfWEwl/HCcoZLz1xMIfZwkMtdl8qHFw
LCcoFGbzocDBsZygUJXNG39MJ8gTL+hDaYMjOUEJp9ttPtQ1ONISkYRibD4UNei2RDTqU8JDQEz0
fNclountJ9yEOaVD4geVul8iWq60CafyRx6ZeVHKzLNJz9EahrIje+TjBV4tKsEM19/jK5aM4YQD
k0DD8/JbpXBr/f2P2/w2JPoQ4QBGcJGFjFgxPMHD3BNjwv1uvOAIIgufNuIVCkKHWZUofQuP+40D
55rHKxRpceDghdspnyjmD36QjXhBLQIFr+zu8WZh/rjJm+ULhybEwBuxlZqsMt5UV9U2ihcOToiA
56p2ngya8kdkfS1QFZ80ooazE2LhuUpaobq9qJIHWSkxnRatUKt7QRRVBlnRUrQUW5YSs7goTjg2
QRr+IIuTdPfRB/Z9r8VRtiLYSEI91igeEcc+kO97LU7vtTgZzk0C977X4vRei5Ph0CRQ73stTu+1
uFA3zQfmfa/FhfnDW4CNeHTt0RPxfgyLU8QZe6ePanGKiGNP5PvxLE7ZIKs9qsWpECQjDX+QxSli
jj2y7wdZnKYKnz6Q7nstDmdNUWraRrxwaBI4970W5/ZanA4HJ4Fy32txbq/Faar84QPjvtfi3F6L
0+EAJRDuey3O7X8f4TiN+PZjWFy4I+u9OarFGfqqlyfO/XgWZ2SQNTmqxRkdZHUHWpwJJyhIvB9k
cXRBVvPwffi9FofjSya7LI7uxwKeaGVx2V6Lo+uxgCdbWVy21+LodizgqVYWl+21OIsnJ4CnW1lc
tvd9WDw0ATxzJIujmmaAZ49qcVTRDFCTo1ocXZIFVHdUi6ObsoDqD7S4BK8UaB6y4z+cfXQxtkSR
sRGPzitXRm5u4dWObkOeT9Jf4YU03DVjaVJkUTvo7TSioBtCHTAiPEbDfIdtRyR2YIWlI+So7zci
x0mDRJdYOxazO0E6I/rE2lE8GWa6T6wdxdNh2vvE2lE8Q7ot+8TaUbygFrJPrB3FC6oh+8TaMTw6
ZQW8/rF2FFUEKfvH2lHUsGjI/rF2FDUsH7JLrB3FsWRxskusHcUJO4rsE2tH8RxZnOwTa0fwwHZU
ONLtEWtH8cJuovrE2lE8FeTrE2tH8TTpsuoTa0fxrAwHzce0OEdnq4DaP9aOovoga/9YO4ZK562A
2iXWjuJIHq4MHGZxjs5XAadPrB3F02Rxuk+sHcWztCLoPrF2FC8hi9N9Yu0onieL031i7Rie5KTL
uk+sHcWTpMW6f6wdRVVByv6xdhTVBFn7x9pRVEsWp7vE2lEcRxanu8TaURxPGm36xNoxPMXJ4kyf
WDuKJ0mjTZ9YO4qnyOJMn1g7ihe0xPSJtaN4lnTZ9Im1o3guyNc/1o6i+iBl/1g7hkonrZi1/agW
R4W6ALVLrB3F0WRxtmWsHYUwpMy2dazdXHDT6aAotmWsHYVwdI5lW8baUYiwfNjWsbZsxjKcTNO2
jLWjEDKMyO6/amlY/jWfr1fPeLl/8D+Iz2550bIJKXgexGQnlSJRNaT7K4iyCckGpfHtL2w2ISVk
CcRet7sW2SgTnsGfnp6y7HbNPufLnJ3AiB7jr0qtqOZ5tdUKL09vtcM1GR+H96eUicr1qZVclNuQ
h5NeRatx3xHSF2p5OOPteg0yDojGxsMhb9dLkHFA/EItD6e8Xa9ARgE9bt08HPN2vQAZB0TunIdz
3q7XH+OAhaIkPS4/xgELfXH7rz7G+9vwDnzP9cYnNKBwfnvQekN1yXk4xj1ovQF7Ic2nQ9yD1hvP
MSrk4Sz3oPXGU57DPeuNxB3kdwbjHrCbz3d8wH5Np7N8zNYLtlovbtjl/7AXb5//xMiDWp3y7yDa
f/zw6J/P9mecj26vhhOav+F6McT5w+qR4+v02aV8Vmy84ulscdX7Gfi+rdbwX2u0NY9wyQP/7FHQ
BGGlso+EFEJgYWeuHnEptBGPGD/iOBs/t7hRMfZoMpumix3tXiyu0+mcfVzly9XfIdff9BHKCizT
AO4LmJ6xbsCW6Xy8uB6wy+XddH6FRrXM0zEDU10ubu7YZLm4Zs/G+ddnt6HlD1WMRKoB+4WuKd6G
gptsAto1YPe6hA55rZPXZsDy9GYxG36FCYZOp7LcxEgPrsiAzWcOtEMMGO0AkzTLcRkQ8FdcCWg1
qHfzEoY0wW0DxErn88WaLWCVZB9+fX325g0DYWBcMwYDmmZ5rbPnovTMogeMYn27YgiUfgXDwaui
lX4Ki8OX+n1c4TyOl1MY2pNRuoKVajGZPMk+gzT5DFarem8lK71ztspvUpjLnL2X79nVcnF7U5qA
k4DM0jH8ez1F+NXtzc0C3K8t4PIUXr54c7FpmY/rTbWuN82/wxPn6YxRRdVaeyttqf3zMQzx27wk
5HQynY/z78y4eseKTM0dhap2FMKUZ+kiXzP8Bn2pPfy4vrvJmWInz9/XpgK/iV/q/QtoOMxu+anU
1bKTt+/Ozy7ffaj1l1b6Uv/z/Fup8/Vi/pS0MiPY8WAj1KkQvI5jVLvh13pqpZWv9kQl2zILsN7R
cjq+ylkOv3gSfq4iadh1B+zniwtG309m4if8y9kLdp2uvsB2Paj+YSecjabrVXVGLBdJ+X18yK9u
Z+l6sbwDISaL5XVYCZ6EZyzvTn85r/f3ptRfgq/wRGon2X+B28De/uvPWnPJyyZmEmWeGKdMY/PK
+4bZAivBKgdCjILeFHY5L357VRa7juUTXOGub2b5ujrp0/l0PU1n0z9j3cCoBuwtPGvAzl6+fHn/
IPZLWAgGzDH26zIHr2We3eEU6CQyEiVsTe8n0Ce0Pvm8Lu6uj08F2Gk2LBaZISw4YLanvP7WjIRZ
//D88uVv4FHhEnMqOJvM0it0m0S9MdoqNRZFY7mjsd4gy6KxMc2N0QyosdqIsUsOy4vWumhtHxrz
rcZJ0dgUjf2OxslGaLuRQ+5o7WTROtm0drta+6K128ye3tHab8T2RWu1Y5CW682b2bxHvUMUSyZK
zTdv0uyQJRHoY89uV59R3RezMe2BaM/oFEzzVa29Q01/kae368/QYJrh2prOZpte9eZeA/y3m3QY
NrJhodx0Fvglvystnwpgrk45w2w2pyfz6ewxgwbD6fg7/DIcHdIPfwxn+Rx+wv9JP1WfKGB2D3+i
6PJEYY8wRtnlifIYT1RdnqhUsnF2avvQt+n6M/v8DR+AGwrsN8lk4PXAjgccmsxBoVbTMfvx+fuf
P7w7f3n5L/FjDVsriyoFQ0H4T++fs/cXrx8Wbaxtf/N5CX+t99MgE+1mTyCc/D6+vb4ZpqtsOj3B
EQj+ePADw48WzHCmJTOS6QnTOdOGGc20Y0qw2OdB1vD32oMNuoAo48nzi1/OzkoSPt4jSpIwa5jN
8E+imLXMCpZIZuH3k6go3/LZbDVJl1eLbVEc7HyJLkQh3z0qCcmg5OMBUwmTY5aNWSqYHzOV4lM5
TAz8MmGZYSpjE8tcwjgINGJekrgCYnOUUo+Zz1gOEo+YkmzCcSJHCRunTCo2tjXZFJcPEccrcKkl
fwYr7uhuna92hxoOYkl0OV69fR0bRqpxDE7js8FpGWXM5WzsUFy8cJGh0CAxDC/JGffMKHQcLPhJ
HqRkYsJguc05g03Lp9jFKcYhCnLMeTaqeLHOeoHq+Tq/A7eAUrzEJMpzQnU4sROBszRJWcZR14xl
XDPrmYUpAqF0IR38cZYaw6x61AwQASwG9DSVTHn8X2nGspTxtCYR+UdgJ2g1s/SuiBpwBQYHNc1g
Jc8ZndEyEHg6Yz/naYah2jK9hpn/nH4FlyiHMCkrIrlqhOAw66HfWHv+fboiT2gTTD2Y/3i6zDN0
A5/Wumsvam7MKEhwEv473HZXoJdLRDGqC5I9Nio8BQK4whfD1WpVR3GqQIn1z1F4HE349avL18Mz
iAHYyX+/eX7+BFaSmlSJTmApw3axt65BlzxLLb54eJcJvFfLcs2UwzeaG5ZZJsFCLCoeFlYfob7J
FNY2Nhqx0YS5FPUTv84JyiyYHjGRs0ziux+ZmiQUJLcd2cXLy9cv//fiBaxijYNzeCO20z4iwz4C
XhvnJs3A5LY2TBHZTJSsP9fAq4bPaLlIx5h+DJvW2khc3Rtkw8xqNM4Bu/+R8Sf/KdjJx/f1QUqL
YVi+nk3nXwbs3UNX/AXGB6dPICy6xzm1tf4Jhhe41ZEqw8QvJmUjWMzzp7UeHhe+D5dvh+cvP705
O39dkhLmB+Z0eO/94jd4T+oSe1sO0M+u5otlXnkkhJF0vsrARLN8KzJcsWoMj5AuAhkwIBTCf/Lp
1fwhJOW+DuDtNsAYNieYxC5AhleCu/2S6Hp/4Q+ZXMO1P/LkGm7NYSL5vu/7/jgiJpbgrWdKcK3Y
yW8f3//+24eP5+dn569+/+3Nu08vPwzhV3Vxhayq90/s7Nc3z4dnv54/f/sS5L+X7seNeD/iulHb
ZQBHgWF9nH+ZP4zP1JvogyzJVA8ujvKyhUvai1RM6pZYPmk5g82zJ2VZaaaT4TK/XnwFlzmd4Znu
HctmeQpbO2xc05KR1VEo7D9sNFL7w0eTHGU0vnZuVjqbpNVl93kZIJDn0/msEzvaiKZ1WNZUYjr1
F6IO4CILdCcAf9jCrAXss9dX1+vBYEznAywbPTTxT4W1XHYbpK71T7Q99ooWcO1BGkwYTqjDNDig
aN5fgwOCqSPs12DsiPzcXzG5Cbfu0MlNBD9sefDiqTZKoQ9zAQ0gdBCGFbn/sBOIcD2dU7LeWh+t
2p6PhfYW3Zs252OheeIcMWpNoRVRUfn1zfoOpIQx0hHJFAMqkGdcBcOvkFWO6XGKtt98hamAjonw
ntaOXS4yj3vI2F1yYvja0DWwQ19cPr88e3f++B/K/i//tOP/5V/J/xudmBL/b4j/t/wf/v/v+FRo
eCOFOZT/xzJVO/l/GeH/jcHToJ38PziQjfy/bOb/QR7Rm/+XprLTtuX/pfS23K8b/w+9K37u0fh/
AHblM7cd/D82tfWmO/h/DV51O/6/6hFipbZKqL29L+gdNL421pR7d6XxtVem7M9GaXwZo/FFHceZ
dsOv9cRCweZg8t0EbrE3+W645eXXt4d8N5javz35Ds2T2iWH3uQ7YHnXnXw3PEHn8FDy3WDeraOR
7wY8I96WfIfGUrUl36Gx4m3Jd2yctCbfTXDk2pHv0NiItuQ7NvatyXdofc/r7yffoXWiWpPv0NqJ
1uQ7tvbtyXdojktlW/IdD+hMB/LdCDp7aku+G6HwiKjV8b4+CvluAiV76BM7kO8GPMy2FMaOJ3Yg
342wuu0Fgx1P7EC+GwkhVpR8l1XyXe4i31/d5qv1j3VgvGfXmXmHfnYX857UiPcEmTFrkPBOdJTk
LhHvJOf932vPJQqsC/GuNqJYiTS2zZHVtpOCeLdjEksW7KytXAYYpfMvi0l6DbOTpXXiXYB3oToQ
77lC2pxr5AUNTEPKxiMmPZuMmcmRKYQ/44T5nHHFMo8y5Z4Jh4SizlgmcPN1I/z9iIjikUHS2mkU
eiRqslncTvoR7xL9rkbiHbwGlyPVObLIZGYcbwJwg/MHAzAZjgcaqBTlA7knmrkJMynLJZsQPw7D
g7+mik1gz/LMG7yFMeH4s6ge/lvMi76XeOcjfHMwSzCrLkH9GoM4Gv+qJkxZnDfwRDLL8gTnHOVN
mXNgk3gEBF6XBDEdEynzAsn2kcerIfkIBzce1SRKlPpLiXf8Ju8BxDtyIJ2J9wRXtIOJd0A5KvHu
OC3sDcQ7vDlQfZXhPY7U4A2WZIy6pwQqJ7d4H6NQywxZ+glZPzixqA0GzUzT1RfUT4f/BoP0lqUp
Xi2xSU0Si47hUYn34DV32EOORLx7iQv3buLda+TMjkC8e413j3sT7x7TRhPxLlsS754LE+F2d/AL
qt4/6cah1MhtAHBuG6A7S45fump9GB8hPqG/iZA5bYlPGSE+ATLpxg/VJ1e6bi+neiseABTnBwKI
bhxdfQRKdrtEsdVfdaO/tvqj9TYybKEJXiU4QG+0EsfWG92etIuLFNO7LrcjGsTyra8WdLgd4bHK
aLfbETLGiAMO8om7bkf44oJ/u5ndGsGW3Mq0p+maZK6Q4H05UCFb63AnllfQgUXvERKGrBwS9R2h
55Ftot1CEOjQ2LWWVv2JKDRKRVbSFtvUFo5VfVfkAiCJrKgtBNkCcvidtm7UrnFJB2o3kVKiR9qS
2sWU83if9SjULoAZUT0EbqR2Rbmjd/ht7J7UrnpqEq8qlPKOI/wytbs1BlgdJNYPda3GUHWGMNkI
Gm6fMVD3RCeu+xj+r8m7I3x28r/q2VGegSxvYkwD/0ufe/43SeQj/Cqh1I+YOcrT93z+n/O/e97/
+DpfXQ2z2+XygBsAO/l/kYDHW/r+v4D3LyVP/uH//5YPxM+UlEdJSuTmvakkFJmW6moNkZLcZHDJ
SklrlFa6nKJJcf0UcanYq6SEbt7blrjZflwqRiExsZsQupJECMu/Zmn2GUs3YSHYq5AfxjupmUkz
q/m4GZaqUUjM7yawWk8rWMewaBr0FY2wPkhrCLaltDAJJs9TO9ZNsF4EaTGDrrCyDWwuOEvyzOmx
zBthZZA2IdiW0nImuU252AGrg7SOYF0rWJB2jMnkuGicW2+CtJjwTVA5vv2w+D0akeVC4HdtGmCp
br0M+d/MluL+sdgU8BaUzQYi0jRtxKLqfJISwSUm2YEVFF9J0aShmrIAY+oByvwjm7H4JsuOkY1Y
mC0asEKhWd2MlW8McjJpxKK6fJJSwyV2awF5wMIz/OLTiEVlG2VIDWd3zP1E78eiao2ScsTVMyVV
sdx+rEInQr44twMr24/lSG0tWgOv5YICrKvZYpTO8CgV45FVKDuNTLhwE66daNJb8GWDjGgO3G/J
uIX7ATNVjkLmKpUr14grSF7MJof519vggtVmDBYEzPQ0asRVJC/WRAPYesbK1XSyGq6n15uUmpt6
hsI2GojQZGxYFE1wUUsruZot1iW4pIADn6MRzpK9YU00wSsZRFG+NPtC4i1u10VlcAgSOH5fbtS4
d2lKA6wwixVAynpRzGy96gHpg5S0wVSKOMbfzqeWb13yICrtMGq/Nr1t+dalDPLiFuNVeQqKwu0E
hN91hF0V/MTGJYySAQMQbSq+rj7gwBIU5/fV5J1phDK0gmFtNHREm6HuvZ5mKCrMJ7EsGkDZGFRY
7wso2fxmJdXkk1gRDaB8o1TiPj1b006pZVASLIYm5Fbp1G0o0Qylgl64kHm6rsLL78PR7WQ1/bPI
XAvrW0BMnG1ExFzRgIhGATtm05QpvYFqnjIVdILKnxm7lVQXIptwe3OIbFyRsFRhwlKrXLPLqSn3
L8Bagt3KJRyH1QSbuR2wNkhLpqD5timQS+zuX2+jrSqqxSepAprXKmpT/D5JIu6dTUA+aK8noK0k
0SWgZLwTSFONRkm1z7CWVck1o+VjNKJ9IgV/u8jk7BtHp8OKQXXPjJJRrE+IxbO9hqCDglDNM6/d
FlaWzmiQqaWk8w4VuMm50zqoBRU8S6pJSCGEnv6BaMPl7TwMVRu3L7bRmoo0Sip5lmi5AzHIyPcP
OKgGFT0Trqxj39LpOkjWCidoBpU5OwTHFIqRHIpTKIU7FKdQCH8oDhV4VZTa9iAcqvurKLHtQTjk
aSj+b9quZdluG9f+ij+BTwCc3nlP7iSjrlPSluR2VWK7ju3ufH6TgPZ5xCY2EbEztb2CTQIQsLBI
hqs4/PBv5Ntsr+AAP/gb+RLbSzhB1vmqP0OUdb7qz5Bkna/6M/Cr4dFd9WfAzDhX/Rm4SYn+qj8j
N63RX/Vn5IY1+qv+jNysRn/Vn5Eb1eiv+jM/g1ZxrvozIsepv+rPtU5jnKv+zI+hVZyr/syPoVWc
q/5MgeM0XPVnSrzO4ao/Ez++GsOgP3crBuJHVyM/Jlbec2CvBc1fqqM+GHOgkd8QKxiHwPq/sMiK
N88u1LGMa0B5ESrTtnVrwOI5jbQXw4bBSheMH+aN7dmwPthvo2D8Km8MmqMP4WROKEFz9CEcpsdj
1Bx9CId4xaPm6EM4hRc7ao4+gJMbodNwtMQ9hMPveMeoJe4hnCjrrCXuIZws66wl7iEckHXWEvcQ
Dsk6X/TndpyHcS76czsA03DSRX/OnhuGmC76c/bcMMR01Z89c04xXfVnz4RTTFf9WajJmK76s5eG
IV315yANQ7rqz0EahnTVn4M0DOmqPwdpGPJVfw7A65yv+nNAXud81Z9D4XXOV/058hQj5qv+HL2s
81V/jlHW+ao/xyTrfNWfI8g6X/XniLLOV/058oQzwlV/To7XGa76c/K8znDVn1PkdYar/px49h3h
qj+nLOs84M+biiONIgz4s44jjSIM+LOKk6VRhAF/1nGkQ4ABf9ZxpDnAAX/WcaQvwAF/1nGkL8AB
f9ZxpC/AAX/WcaQvwAF/1nGkL8Cr/gzSF+BVfwbpC/CqP4P0BXjVn0H6ArzqzyB9AV31Z5C+gK76
M0hfQFf9GaUvoKv+jNIX0FV/RukL6Ko/o/QFdNWfUfoCuurPiLLOV/0Zi6zzVX8mx+tcrvozBV7n
ctWfKfI6l6v+TInXuVz1Z2LVSixX/ZlQ1vmqP1ORdb7qz0X6AnVwOITjZZ2v+nOJss5X/bm0t+5j
UgeHQzg8QErq4PANTo9prZ/lzDisMkT89Qj6a/1nT1+fv9xOoprfd06JVtdTp+XC/WE6n8XMs3DB
ObGXR+bv3x78JW4bnEd8SKwDv2lYcZv/k4sj9pYm0zpyWsh1RQPgotgLjGu2t7dv4LLsf4sP8h3p
wC/sZVTYe2rFdsUC49Ls9SWxt5jWt/nvQVtaYxe3sL08uJy5vp7rzMSDzPH1FXWL37uixfZQC+OG
yevrk9gbTetLH/bt2OloFyV0cDPnKx58Tl1f7ksTD0LH11ckNccNe2Mo8CT2wuS8E5zYi5P3LXix
l0z7dmt556h/sbtvIYq9ZfK+CZ+ZeLA6vm/n+JByN+8ErmMSD1qnri+KvcGyvu0+tO0oPrueihFE
YplCnLy+ordMPJMdXl8vuMGV7vrGIPbmyesbo9gLpvWtebLmndtxdOMt5sS4OHt9mRdJPL8dX1/J
68e69+TJEEnsLZPzTuQDRYnnuzP3LbHQIvG8d3zf2s04acuue2oFUhB7w+R9E1418Tx4fN9OCSZt
3bhIWeydXU8mqaujqZ70Na/vR6G095S2kKSujrPrySx1dTTVk+cpJn8s3fXNUlfH2fVklro6murJ
0HCPwx9H77wCZKmr0+x6MktdnUz1ZHAP806Wuprn0zPzTpa6mufVM/dN+NuUkmnf0ocjpNui5B2Q
ujrlyfsGUlfzfHt83+4q97UbF5DF3tn1JEhdnUz1ZCDOO3vqnkAFkLo6za4nUerqbKonA515B7rr
KwLSlGfXkyh1dTbVk+1CwXIcSck7KLxQnl1PIoi9pnryPDpS8063z0Kpq3nePjPvCG+ceP4+c99I
6uqMln2LtQ/AumvtYF4PV+rqTJP3jXiulHheP7xv90OTpR8XJHU1zK4n5Zh+AlM9WZFa3lly99A3
iEY1wex6Ug7qJzDVkzGdfVa/3pGT+glm15NyVD+BqZ6M9MGH44hK3pGz+glm15OFdSsJTPVkPPmd
denWOydfzfqBmXnn5KtZTzBx3/Dkq9GZ9q1+L0K+bc73Dp7iyVejn7tvePLVrD8Y37eT31m6cdGe
emHcyfUknnw1murJJrT3B+652xfiyVfj5HoST74aTfXkeTAgQLf+xZOvxsn1JJ58NZrqyZQ+ABz7
dhzddTj5apxcT+LJV5Opnkx3fsf38g6efDXrISbOyfDkq8nQv60juCdfTbPj7eSryRBvS5s7hb22
7A6wiyt1Nc2OtyB1NRnibbnPybzvx9vJV9PseDv5ajLE29LmTtEdtwWg7w9SV9PseDv56mKIt+U+
J4vtmpMertTVZXL/hidfXQz929LmTr64sB9H784jjFnsndy/4clXF0P/trzMycrSm5viyVcXQ/82
lHdOvrpM7t/w5KuLoX9b2MwMt9VBr3/Dk68uk/s3PPnqYujflvuczIe1vw5cV2c3uX9D4auzM/Rv
y8rp8dgddPlJFL46u8n9GwpfnZ2hf1vuc7KYuvfCofDVeba+BHMExjX0b0ubO+X6l29K3hG+Os/W
l6Dw1dmiL1le5mQFunlH+OrsDP3bUN4Rvjq72f2b8NXZG/q3pc2d4tJa4K4OBIWvzn52/wZ8YDl7
Q/+23Odkvj2S1cPlujr72fWk8NXZm+pJvhTt2HdYuv4gfHX2s+tJ4auzN9WT99v+Yuyug/DVeba+
BIWvzhZ9ydLmTvHmonKrHSLrQPJsfQki19XZoi9ZXuZk5dbNO8JXZ9GXTMw7wlfnMFnPhcJX52DQ
cy1t7tQuGqx5p8enovDVOUzWc6Hw1TkY9FzLfU7W7ijr4jJfncPselL46hxM9WSg1mcdAUqPT0Xh
q3OYXU8KX52DqZ4852QxLN11EL46z9aX1LDgOsqiL1na3KndPaTlncIXseTZ+hIUvjpb9CXLy5xM
yTvCV2fRl0zMO8JX5zhZz0XCV+do0HMtbe4UI9y2Pr9DwlfnOFnPRcJX52jQcy33OZmP3bxDoq/O
cXI9ScJX52SqJ2PieucGe0+PSMJX5zS5niThq3My1ZPnnKy1qT1c4avzbH0JCV+dLfqSpc2dMroU
+jpoEr46z9aXkPDV2aIvWV7mZAV7eYeEr86iL5mXd0j46pwm67lI+OqcDHqupc2dYsQNHXbtFb46
58l6LhK+OmeDnmu5z8k8dG8hJtFX5zy5niThq3M21ZOtHcRjK3h0/Uz46pwn15MkfHXOpnrynJPF
2627DsJX59n6EhK+Olv0JUubO21QA+44eue8SPjqPFtfQqKvzhZ9yfIyJ6s/sIsrdbXoS+bNyUj4
6gyG/u02hCt1NcyON+GrMxjibW1zJ0+wbc73+D4SvjrD7HgTvjqDId7Wl/NkZe+vg9TVMDveTr4a
DPG2trlTbS1ggb13Xo9Ovhpmx9vJV4Mh3taXOVnunuugk6/Gyf0bib46o6F/W9vcCcKxKXojkotz
M07u3+jkq9HQv60DczI6+Wo09G9Deefkq3F2/3by1Wjo39Zmpl+wOlE/75x8Nc7u30RfndHQv60v
58nWft4RfXXG2f3byVeToX9bee7kDySEblycfDXN7t9OvpoM/dv6MicrubsOJ189W19CJ19t0Zes
be5U9mPblP5N9NV5tr6ETr7aoi9ZX+Zk1K+rT76aDP3bUN45+Wqa3b+dfDUZ+re1zZ18weCd78bF
yVeX2f2bPIOWi6F/W1/Ok926uiCSZ9BymV1Pnnx1MdWTPHc6as6KPf0DnXx1mV1Pnnx1MdWT9zkZ
lu46nHz1bH0Jib46W/Qla5s7UTj22r9160nRV+fZ+hKSx9CyRV+yvs7JcjfvCF8Noi+ZmHeErwY3
Wc9VhK8GZ9BzrW3u5Ff03nX53yJ8NbjJeq72YjvjGvRc68t5slt3flyErwY3uZ4swleDM9WTbe4U
DrrV1N7FJbF3cj1ZhK8GZ6on73My7K+v8NUwW19ShK8Gi75kbXMnXPnejl68FeGrYba+pAhfDRZ9
yfo6Jwu9vFOErwZvuC9oJO8U4avBT9ZzFeGrwRv0XGubO7HCwfXXQfhq8JP1XEX4avAGPdf6cp5s
6/LVRfTV4CfXk0X4avCmerLNnfJREmLv3EwRvhrC5HqyCF8NwVRP3udkpb++wlfDbH1JEb4aLPqS
tc2dFnfsR/9cRxG+GmbrS4rw1WDRl6wvczLq8jtF+GoIhvuChvKO8NUQJuu5ivDVEAx6rrXNnXxK
KTrf64+L8NUQJuu5ivDVEA16rvXlPFn/Mb0ifDXE2fWk8NUQTfVkmzulY11S7tY7wldDnF1PCl8N
0VRP3s+T+a7eswhfDbP1JUX4arDoS9Y2d/KLeo61CF8Ns/UlRfhqsOhL1tfzZKWniy/CVwPrS+D9
ozSM22B//7JsT8u/Pz6Fp6/Lt2/7t+FxWRHaGlhmgu7ntNaB52cG88n+9VVYRW5zBlabtJt5rfAV
GhV44Mu9QS41sVqf7tZ3cx1IThLtidX6dLe+Dy+piSUoZuvpbn13a0EyFCtRzNbT3fo+PD8QASxI
+R84JvB7ISC6FNPirC+OuXflHrWQEsck8+II/FEOFV6qJlapmK1Pj61nES1k93esb4656tbz3fIg
d6JYrafH1vPbZCDSFav1zTHXfdXg+QUCYAXL/8AxSRq6bI/a26tj9r9PxO+TQLZHrcAf26HC8/XE
ILIWq/X3jNlfe7mtGjL+HeuTWK/Bgzgm/R3r6fHay8cwl79j/d0xFXihnETywq9tj8KX6pAf1kDJ
rWtv8lqKZ8cU5Uv4uQLR4Lfbh/CgICv8UiKwAMbld/Df9u8/vrYC59P6vHz/9OXzidrGr7XuXDTU
xP7I8pf25JmOKo/vPXwvuZQstiZGLeO2etVWFFtzewX751fE2Tx/uJfH4Lu9ZBGuqWld2qr/Esg5
/wLUISli/SN2WBa3tIefXoHaRn8+5NqC3de2bovBH6UTWbG9MsNIxEj5F0i/vUOKnUFGRZKiiQUs
XZsWRrrt9f+r2CS+wZKVrk1vkEKniK5IQkaySKVr0zpkk9CPLEvp2vQGKXSE2BVJPlMsRAmYfoH0
j3++Xs3uulez12adn8oBlp60Z7suIElzz2KTgPgYqesFXrIFy0sC/cqm/x+1KcmKNx+Pvmg+XjbV
M32WFW8+HsOvvOC3d0h9L/BSwbBopGuTeGbxqmd6oX9YJtK16Q2SYpMQPiwM6doknlmi6plBuiqW
gnRteoPUtynwo0nA4o8Q3kZL/ZvP358+H7f2pupbp+q/QVDhZFbBmo8QymU48QeWerRn/Mbguu4V
xCmawsMn967uXNen/yzfb//avnx8un35fHz6KB6CD79lkaOnwSLDpkewv72H7czzY3MYhqUGG90Y
LMsij3Y/dxfWi7UtMuqivoV9/vNp/7ysv+/n9809/u2RD4cBizpSim92aNm25z/XH8fTvv2xnICY
qkPWItj12KoKyKfCgNUcY4C0xEUD5PE6sIxj0EK3Jg2Q398D1m+MAe5pvWmAJBam8Z9M7lAAEz/d
DqzYGPzJvqZ4BVBaHpZqDALiDhqgNDms0RgETBE1QBlesThj1G28timJb9sEVmWMus3mNUB+lged
IVJSXDVAfp8H3XikVAu1SMn8cCu68Ug51hr5CmAQC8cjpeBNc2yhhtEZImWJmmMLJ4zOECnupjl2
BrFQIiU/AuTbiG5BAySxEC2AUQMsiQFpHDBFzbGB33NDVywWqoCBLfRuHBA2LWMDTzLRe4OFm7aG
8sQf+jAMuLuFNEAQC6PBwlX7jNbakAHTMCARaskBeE6APo//5LRqgOjFwvFIobJonwBk/Q16Q6TU
T6QGyMUs+vFIoSVou4xZLDRECmQt2whPi8EQKd5r2abNzRugIVK81yKFnFg4HinHumvfZeIGGIMl
UjYtUojZEAzjkVLzoZZtKImF45FS9ORAzJVhMHxTcNcSLDFNhmE8UqgULfSIxEJLpHjtJxem8DFY
IuXQ/LCwGAvjeKS0K9M1QFZhYRyPlJq+tFKk8DPjGMcjpXYBWn0o7wpiHI8Uame6FEAUCw2RsqqN
jyiJMRoiBUipD71IiDFavilFqWC9aIcxjkfK7lZlU3ztbxnQECkUFMeuLsrpK1oixSu77B2whclS
faHykfKOdXqYDN8U2NWfzAI9TOORUhOsEnreO7FwPFJ2t2tu4wMnh2SIFLdqa+j5jWJMhurL3ZQE
6z2LzDGNR0r9yeoasgoGk6H68l6LZU9ioSFSyqKFnuf3qzGNR0ot57RICZ6TQx6PFCLQHDvwS+aY
Dd8UUmM5sAoBsyFS4NA2JbB2E7Oh+gKnfAJ8ALHQ0qfogPzKPWbTN0WL5VA4OWRD9QVZA4xeLDRU
X6RRpj4yh4/Z8k3JSjnnIw90MFs6eq0185GnewiGb0qK2i7XJooBTR29lr4ic/gIlo7+0DYlObHQ
Un2hlr4Sz38RTB29toaJqXuE8UipgNoapiQWGqovwl0DZOoewRIpqKWvxNQ9goH7qslGAySx0BIp
GlVVszknBzREitu0T0Bm6h7RFClaKZKjWGipvjYtOWSm7hFNHb1W22Sm7hEt1demZews1D1auK9N
88Ms1D1avimbwtt4EOoeLdyXxnB6kMYHxyNld2onBULd43ik7G7R0hcIdU+W6itpjg3S+NBwpLjt
RgpF4AE5OZClo9fmKR6EuifLNyVpyQGFuidDpABpmyKqWiRTpGjfFBTqnizfFFAtzJwcyNDRJ7WT
qp8nBrREyq5uilD3ZPqmaJ9RZFUjFktHX7Q1JD5Bi8XEEmtrSELdF8M3pbZzGmDi5FAM3xTvlWmF
JxZcY7FEyq6VcyTUfbF09Dog65SwWDr6ogKyXAnLcKS0fKjVNnLhAxZD9YWHtssieMViYom1XRat
KzlLpBzaJ0BkruRMkaIVS4XVjeQMkZKilhxE6UrOECm4K2sYnBMLxyPlWDW6LzgWLJEbj5RjBeUn
h/qrGdASKYeyKbUwEwst1dehfPWC44NBZJnRgxYpwfGZRTLM6GtyUCrY4Ji6J8OMfm93C/YBaxQx
4HikVLdRWrNQPxAMaOG+nGphFAstLPGhFJzB8wWxZJjR12JJ22XPJ+3JMKOnReMPg0ex0MR9abHs
+cwYWWb0qGlFQuBTYmSY0VdAzW1CEAsN3xS8ackh8DUxZJnRo8a0h8DUPRlm9Lu7KeVcCCAWWriv
Vf3JrFkiw4y+AqoWMnVPlhl9jtouRy8WGljirOkPQ2TNEhlm9LQEFZCpe7LM6BdtnhLk2gUyzOiL
W7VsE1mzRIYZPbUeQAFk6p4MM/qCGlUVIlP3ZJnR1zhVABNrlsgwo68fKaXxCYmpezLM6CugtimJ
NUvUZvTtJbg3gN/2789/Hp9+/74/M1x7jexDk3bfUum89VDhWLFEbUIfMCcNzt+v8uyrxUPipofa
fL6989WD+0f7sfHh4aqQWK1EbTrv2y0z7+Cevnzd2/mxzx+f/viy7Sfq/ciW76NmJ0Y23X07MfAQ
lZqIf6X6IU/dYyQ1aYutNVoC/XUl/7gt376/25u6w8f5XxeR+Xtqg/p2Ge9DxPQYkZVLxJN679/+
8h9ft+X7/vTHp7X+m+9yFrdWk48uiaiQTOETz+rbxVuPIOmxE2UUKyNDhsdWpseQrF8intd7Hx9b
+fBgRAAm8okn9u3Q1kMrByC9WMnfGHg5sSVHNhre0+3Lj891x7+dERke/3KIYiZ/Zl5PTCqYA3Yy
oU8yuX8NoB4mJ9yHmMzpkwzv0T+2Uy68Ciom0/ok83sMA5jtMrwHdkqByyN8/3oAavn8qZ0cbYeW
7uv42NGRSX3i6b2Pro8VH+8zMp9PPLj30StYj9cNpRHimb2PQcF6vF7I8iXKeV7KkXt8iQf2k1KO
XOFLPLKflHLk9l7iof2klEPSC/HYflLKIemGeHAfMf5lq3eD05C0QTyxj6+HaX9CeuwyxIMf4lE9
vDtMy7739fbjeb/tn/59/zingZ/JpzaIh/XF/+VT+vSp5YDnH1+/3/PV4qql9avve5fTxXaLMiO2
GCnhr0XEz4jNB2+6jdIDybMOgd4gngnrJ9DX9N+5yyqGIn0Qj+wpuoeg6V40tu3uggaxlC9win4E
1D0GTWIp394U4wCoZNgQj97TrRVUeiIZ359F2dOnb7Vk+r9/skUPPadIEySPNsDbBaz2PH/dP28c
bPUn0uOfyIMf4lG9p3d3InxsTtPsGsbimQ/xlL6RLh0sdCk9wmrH1xmLvx0l9bDaJW8nVu9S7diO
9DIWfzveX0b2/jc+rjOikxYZX08Hd+y6/be96+tt41b2ee6nmPtUB6jT5X9SgC+um6Y9RhInSJzT
AxQHxmq1soXIkivJSXw+/Z3hrGzteqXdlZTehyvCbWSZnB2SM7OcmR/JFnzFHT0+ZuS7WAC9zgLQ
FpxI0e3LAqiE/WPHFy6v6tXn0Xi8Sf/Xk4y7ejzfreDlJpIfWpIU7CN7PnZaN3C5alDWk2Qv2T/e
GLSJy3Yk2U+OuXnnXSOXzcs1xYcXeL5HwftGLtuQZH855udNseJnuX7Vzj4pPr3A82UJpR30a22x
bjKbig8y8HxTgnKbiX5oqS9SMKeuNdEWwiglcxoPlHh0Gxbp/POY1hwtzbySnBj00XsvrTnQ0izm
Q6uLNZVpQSuCIX2Ifrvz62npKCDah/66AxJwGRnFmDLxdCHEbnxxNCUm4feyCELzEsU3ZuH3YwIV
R1H4joM9LYIUn2Hg+YKDPS2CFJ9j4IPd4yJIKc4L8tUGe1oEKcW5Qb7XYF8mQnF+kC816GYi1suT
jjnCENPzXU3E2tnXMU8YOEX/KFIPJqKtpeUjDQJl5sXKyTzL4zlak4nBk0D5+E4BXC083F7fJ6uk
4gawkOiOwds6UlFGQmI6Bm7rSHkeb7t7BxksGyjvvmsHjeBh97t30CgedhR9oYJdFYTLxbf27xwT
LUjgFHuy2rvoMC++/XWX3/FRLYJDaCIR2bozzRTd5BjpRUFPwmZ6vJSnbMi603QUx2EDJ9hLcZYn
9JKwXIKvPQda0Y1DkV7MhQi/kT9RjB9d/LGOHkdgA6fXld3c34zHLzHr7iFTisOvIWbXSVw29TfV
zYaHQ68hJtcTVZFelJS/at6QBVWVrIvh04GpkaqLVF0rqr6ZqmVe6R2Bk9OKavPbnAOwgXLtQkvx
RFPa2kwb4dSBUuw7aZyL20cDZ9YbNS6eN4UmKlmXPVMcdA2cWG/UON2ocRx4DZxXb9Q43ahxHHwN
nFZv1DjdqHEceQ2cVW/UOB4/SvyvpRfDriEm1fehcRxzDdLtVeP4vrQQE+v70zi+LS3E7Pr+NM7H
faSBUuw7aZyPGJRAmfWdNI4Dr4ET6o0aR6OGQ5ZtGLUYdg2cT2/UON+ocT4i7gNveW/UON+ocSEC
7gPveG/UON+ocYGlhDe8N2pcc0gtRLh9iPvd96FxIaLtg/J71bhgWYrDXjWOw68hbnzfn8aFGGEL
lFPfReN0EjH3gRLpu2ic5gBs4L3ujRpH/aMj5teOmuYgbOCt7o0alzVpnE5iSD7wTvdGjWu6XQTp
xTBs4KR5o8ZlTRqnOQgbOGHeqHGNIT6dFPLh96NxmsOvQYd9apzmCGyIqfK9aZzmg2NDTJbvTeM0
32sWKG2+k8Zx8DXElLl7jF51UTaOvgbDp1yvTsbtHU5t/45Pao3yK+gCuU20Ipgt8LHzj6H6Lj2S
LBuUGW9tQ0wdnbhdJ/AO9o6eaS09zSPtt/BMa+nFzTqB96939Exr6cVDCgJvX+/omdbSY7Hg3esd
PdNaeiwaMSPe1YbU0eMTCgIf+b6VDamlKplLvbUNqaWqmVeztQ2ppWqYV9vBhtTSifH5QKnwnTSO
jycIvHG9o2daR0/HyHzgxHdHz7SWXozLB9623tEzraUX8zaBd6139Exr6UVkY+BN6x0901p6LB8x
Jb4PjdPxRLbg9F41Tnvm0uxV44qoa0yV70/j+JyC4NyOGldEXylJvpPGmbinK/B+9Y6eaS09jr7y
dvWOnmktPY7I8271jp5pLT2OvvJm9Y6eaR09y7ka3qve0TOtpcfywanwPWhcEX31Zq8aV0Rfvd2r
xhXR15ga35/GFdFXPl9+B40roq++S76jjk4RfQ3t8h1lz7SWHkdfQ7t8R9aocUX0NbTLd2SNGldE
X0O7fEfWqHFF9DW0y3dkzfPB0dewTb6jll6ERoewfb6jjiqDXkPYPt9RS1Uyr9vnO2qpcvQ1dMl3
1NKh6Csu4R6vqdromdaSoMNOkIRo7Zn69bRIUJCWbOeZ1pII3CPVDMRMYP41vb3NZyvNQ8K90e1R
mGsICe5KdLJLF0hVCD3AE+UaQnQ8LBKy7bGcawjROgQJudaAyXUcUWDt5OQEsrsFXOezHI6wO8/p
q8daJt4sU641J1T1k3oUAkhYBJUytWz90YItE33/hAVRRau1Xf9MPJowWUphN3RkLT0KHCYskl2h
kbX0KLycFDLaERdZSy/wDJgtQJF19BQFmBOW2K6IyFp6FGhOWHC7wiFr6VGgGf/om7GQtc0Nd68F
1Lu2uY3SJTrgvNcQclGsIgpjFwtjVIjyFOEXu1gYo5MoSELtaGFMvHi8wcJo6wnghJ3uRdxMD35L
R+N8AIspzBfTW7j4F/z69vQniIuL+UnyDTn7rx+eHUqlDPL+3dXlMA7e5WJ6SYNHt0gObtKfL9TP
xStWvBhPr7Z+Bs211Rr/tegOm2dk5HDd8mwpBVokz4QUdDoxrhDlM7qGXLlnkOyxn2vLHb2XAJ4N
x6N0uqHer9ObdDSBT/N8Nv87+PqbilBWaJwAXPgKa5ywPZilk8H0pgcXs/vR5Io0apanA8jRrkxv
72E4m97Az4P8y893XPOHMg1vXQ9eRrjiHV+8CUOUrh48yBItVMuNbBJCD/L0djq+/IIDjI1O5GoV
a9FtNT2YjD1Kh+hBtPvDNMvJBgj8lcwAQ+jKzULisUtDelkgW+lkMl3AFO0jfPjt9dmbN4DMYL/G
gB0aZXm1sXArzyxaYC8Wd3MgQukXVByCjJbaOVqBrLT7NKdxHMxG2LXjfjpHMzUdDo+za+QmH6Op
qrY2otQ6h3l+m+JY5vBevoer2fTudmUAjpgypAP8/2JE5Od3t7dTXG09IbzanYtf33xc1swH1apW
Vqvm3/CJk3QM8WbVSn3U75X6pwPs4tfJCpOj4WgyyL+hCyqrLU1o11KVGwpREoiP+QJoK/1Kffy4
uL/NQcHR6fvKWAgZVgf5JYo4Du/qU2NTC0dv352fXbz7UGlPO/NW2p/nX1ca30wnL6JYZpHsoLdk
6kRIU6ETEtWu+5WWnq6OK7ckKXuiF6i+/dlocJVDjl8c8+cyJa0E6sgvHz9C3KgM4if65exXuEnn
n/Fd3Sv/wFEC/dFiXh6RYBOzys+H/OpunC6ms3tkYjid3bApOOZnzO5PXp5X25dGFBf08liiBw3/
g2sGePuP/1Srh9XpN06ZY+PRK1xTXdiKmKGa0PlnQvRZbgrFnBTfXq2yXaUVLJm4m9txvigP+mgy
WozS8eg/dc0kTfVbfFYPzl69evXwIHjJlqAHHuC3WY5rlkl2T0OgXU1PpKjK/RDbcO2j60UBYh+c
CFTU7LKwMpdocVBvT5LqrGmJ1D6cXrz6Ex0osjEnIoHhOL2iRZOoVlauqCyKynJDZb2kLIvKxqyv
TMITK6slG5v4sElRWxe17WPl5EnlJdOmqBw2VHZLpu2SD7mhtpdFbbes7TfVDkVtvxw9vaE2CVms
HYraakMnTaKXM7OcR72BFVxmLasvZ9Js4MUKWmGP7+bXJO7T8SC+BEmfaVUwyueV+i5B8r/m6d3i
GiuMMrKt6Xi8bFWt7hWS/3qbXvKb7LIQ7hgk+5zfr5hPhWSuThKgY21Ojiaj8XPACpejwTf8kmNq
8cNfl+N8gp/oj/FT5YmBXrG7PlF0eKKL1nHXJ8ouTxRG7/5E1eWJUj2sdirvoa+jxTVcf6UH0Asl
JD037AXds4NeglUmKFDz0QB+PH3/y4d3568u/iF+rNLWgUQKu0Lk/3h/Cu8/vn402nTJ/e31DH+t
tqM1T3ybHaMz+W1wd3N7mc6z0eiIeiCS570fgIoWYBLQEowEPQSdgzZgNGgPSkBdeeSVf688WEnU
X+Lx6PTjy7OzFQ6fN7DiHFgDNqMfp8BasAKcBIvfD2tZ+ZqPx/NhOruaPmUlGGOCL1iJi/daTiIP
Sj7vgXIgB5ANIBUQBqBSemqCA4NfOsgMqAyGFryDBBnqQ5CRXQHSEZd6ACGDHDnug5IwTGgg+w4G
KUgFA1vmLXgyikuX43dcU8vkZ7S4/ftFPt/sa0Tzi3bm97ev67oxdCAsDWHmwXkwAZSG3IHJIQSw
AYwF04e+Bo/ODf6aQn8AQ4FaAH4IqQI3hNxTh238E1YIKaQJZCm4UOYkOIOz/Tq/x2VBPOuljiN8
mskgxZWYBDHApTCInB44sHG4kDyyk9JfswAUB8RfcVQtjbOU1BZfXDjIeQYaR1LQ1KQGUgde418r
HHla1KGekNaM0/vCbSALjAvUNENLnkOMyQIyPBrDL3maka82S29w5K/TL7gkytFPygpXruwiBPKs
5FLb82+jeVwJLb2pR/UfjGZ5RsvAF6XmLklcqCxj+szBEf97WV2u+BcJGlEpil59jLzX9YpiQEiu
WIuRtZpXqdDSJFKpa58T89Qb/vr3i9eXZ+gDwNE/35yeH6MlqXAlEkneEtarm/WsDzKFRIPESe2T
LgkHKifh1Bb7THM5HNIPzbohyUgEJCiTCqSAvgIxJFHwiuZ7oEk4ce5R5ZKAAlThREnXvmcfX138
X8cfDuVQDuVQDuVQDuVQDuVQDuVQDuVQDuX7l9U0PO0u4Nz9uhhOTHrnN7eLeziGcZ7GWOyIIjfX
o0kpPiSUEbqUPM9vpl/yp4nNEyH1akMdQSHYMF+MR5PPPXh3m89iuKIH9AXl6k6SnyiHz1+f2Erz
YFrmhSUcfbw4vTh7d/78/y0yqB3+R35H/I8wNhFP8D/aHvA/f0dZVVnjHaUFd8L/GO+t3oj/kU/x
PyYkvgn/I1Fy1uF/5Hr8j9TBbY3/kSaxW+B/rAxSbo3/wdbKfw/8DxLWqh3+h6qGLvgfEUQogz9G
c8qCxGwCjvHNDeX42MzAEVnfE5n45zgz+eLkWAgNR+/4RgwUl3RMAncfJ3U2vZrl83kVvRNKcKPK
427SRXZdCcULfFZiq1TM6vQ+IkhnS3qnGctvJIu8ZMgKzeUxjK4m01kOw+kMBeFrBdOTONEO01N6
81mv7RNoR/nVpTdAmlDvErkDpClIY2QTpEnWQZpslU4JyLMJ0lRpqZSWuwOR6O7dXYBIdBNkByAS
3V7XAYhEp6TvC4hEJ7ZuAUSiQzr3AESiMwX3B0TCf3VrIJIWwrYGImlcYbYGImlBGIa2QCSsHVoD
kbTQtjUQSYsHQFQLIJIWVrQHImFt3x6IpMUDJKoFEEkLrzoAkbQISQcgkpa0TmgPRNLKhQ5AJG3I
/raCzOj9AJG0VW2BSBue2AWIpJ2Suz+xCxBJ+308sQsQSUfLVANEkmUgktwERPr9Lp8vKigkk5Cl
645CMgnBFtaikFwFhOTAGUrwOwVO1wJ+VkBIkc+H36vP9b4bCEktWbGSID02J4SPHRYgJDuIbEmC
z1hF36yUfjr5PB3iSmmGelYFITl07GwHEFKuCBOTaMLqGEXgmEGfEBTDAQF4ckM/Awchh0QRcAJ5
ygMIT3AZnUEm6OXr+/R93xGaom8IQeE1Md0XFd5U2BqE5BNFL/Q1ICRLu/lA9yHQGb/Ql8Qu9mqY
0VgOPIGtfA4OebVghpDnNPuEQos4D6ovCYfl+gRFwrbS0P+dI1xVlpY5MdLrRhBS6gjapHJ6uA9E
Bsct69N09gUhUnTkboBs5jSMOGLOkjwSKE7Q98JGZBh+zmhUc0f10zhHTlQ4egTafBcQkjdahu1B
SJ5CD51BSEJIWijvCEJCKs7uE4RkpdJrQUioPCqQEKJciSHpQK4Jembp74907Av0IiJakPR5Nk0H
dP8fMV+p4/x6NOv0MWD38BGS4/8WcPRp1WdhQnGtvSnWdyzWBPuoPW0P7UXLHmcPR3E6XJ336SR/
UWmhDS1+Lt5enr/6483Z+esVLvFFiq+iy4fFHh2hf1Th2JiSp3vGfuDqI9HXyb/g9AFKZZY/iVTM
YdV5ZpIlh78gyTTIwcT/cvQ3a3fCcHuT7Nbeit3aO7lbe6+fth/kY5KBTnSC7cSHrIg+joPaipGn
hGQ3Tqo9sapGyDq0d9SRHYTclWLoexFyR0GRHVjySY2Qt2LpIXZRx5aPnmQrttBDVXD056f3//7z
w6fz87Pz3//955t3f7z6cIlfPWFXls3MT3D225vTy7Pfzk/fvkL+H7j7ccnej7TsXX3BMR3acvNp
8nny2D9TrUKxupYj+6QHT/g2oSXfG3j2pVDt8HIWkz+Dh8heNs5TfJc/xtFixypUQrKbVQp1yrxJ
iXWVgNyVgKrRoi490Du2L+333KI9bbHbv27YJHG7yphNShZySxmziUNObq5uFr3eIEYJcClcTmPS
emjXlxPTCd3EuZwWxY8mqXnLtnk5VQi5hBTrI9bBdakwUFxzSSOF434zmsR7qatt6IXWNvCiicX2
gRdN1+6pPSWeiVhppDcknss7ilEsyUvfMvFsrcNVcbvo/SHxfCiHciiHciiHciiHciiHciiHciiH
ciiHciiHciiHcijfufwvYhASOwAQBAA=

--_002_1AA9BD91549CF94C901B05C32D2B08117B44B788ES02Chwgtinet_--
