Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54368 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab0GURWL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 13:22:11 -0400
Received: by fxm14 with SMTP id 14so3744102fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jul 2010 10:22:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTint5uT6PQ8pmEIVSoVYOSCZE5k-TGB1knwHtupw@mail.gmail.com>
References: <AANLkTiknLRzt2bdhcin5WRzwPXSWqEs8dIUe5imlN0I9@mail.gmail.com>
	<1279572443-14361-1-git-send-email-linville@tuxdriver.com>
	<AANLkTino_4FKtMWZU7_lKGzPUXNOtfrmlw_rmmr836eA@mail.gmail.com>
	<20100721133320.GB2355@tuxdriver.com>
	<AANLkTint5uT6PQ8pmEIVSoVYOSCZE5k-TGB1knwHtupw@mail.gmail.com>
Date: Wed, 21 Jul 2010 20:22:09 +0300
Message-ID: <AANLkTilkrTI-BdCEiGlA77IUGl6I-iF7ZsRV7x83jbaB@mail.gmail.com>
Subject: Re: [PATCH] rtl8180: improve signal reporting for rtl8185 hardware
From: Pauli Nieminen <suokkos@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 21, 2010 at 8:07 PM, Pauli Nieminen <suokkos@gmail.com> wrote:
> On Wed, Jul 21, 2010 at 4:33 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
>> On Wed, Jul 21, 2010 at 08:08:41AM +0300, Pauli Nieminen wrote:
>>> On Mon, Jul 19, 2010 at 11:47 PM, John W. Linville
>>> <linville@tuxdriver.com> wrote:
>>> > The existing code seemed to be somewhat based on the datasheet, but
>>> > varied substantially from the vendor-provided driver.  This mirrors the
>>> > handling of the rtl8185 case from that driver, but still neglects the
>>> > specifics for the rtl8180 hardware.  Those details are a bit muddled...
>>> >
>>> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
>>> > ---
>>> >  drivers/net/wireless/rtl818x/rtl8180_dev.c |   11 ++++++++---
>>> >  1 files changed, 8 insertions(+), 3 deletions(-)
>>
>>> I tested this version of patch. Patch didn't apply cleanly for some
>>> reason even tough when I mnauly typed it diff looks same.
>>
>> Please try the v2 version of the patch.  Some "back of the envelope"
>> math suggests that the v2 version of the patch will give numbers more
>> to your liking.
>>
>> John
>> --
>> John W. Linville                Someday the world will need a hero, and you
>> linville@tuxdriver.com                  might be all we have.  Be ready.
>>
>
> But version 2 doesn't change the fact that driver is going to report
> same signal strength even tough I know that only one wifi should have
> 100 % strength and others less than 50 %. There is only one router in
> same room with me and all others routers are a lot more father away.
> So driver is either reading wrong bits from hardware or my hardware is
> broken.
>

yes. This time all networks are showing signal strength of 100%.

But I added some debug output to driver:

printk(KERN_DEBUG " [rtl debug] %x %x, signal %x\n", flags, flags2, signal);

after the raw signal value is extracted from flags2.

So what is in flags2 & 0x7f ?

[  933.501140]  [rtl debug] 30050115 27e26, signal 1
[  933.506067]  [rtl debug] 3005004b 27f06, signal 1
[  933.518955]  [rtl debug] 30050067 27f40, signal 1
[  933.553504]  [rtl debug] 30050093 27f14, signal 1
[  933.574740]  [rtl debug] 3005014f 27f35, signal 1
[  933.603517]  [rtl debug] 30050115 27e36, signal 1
[  933.608457]  [rtl debug] 3005004b 27f10, signal 1
[  933.621354]  [rtl debug] 30050067 27f22, signal 1
[  933.655899]  [rtl debug] 30050093 27f0c, signal 1
[  933.677129]  [rtl debug] 3005014f 27f5d, signal 1
[  933.705938]  [rtl debug] 30050115 27e35, signal 1
[  933.710849]  [rtl debug] 3005004b 27f14, signal 1
[  933.723766]  [rtl debug] 30050067 27f1f, signal 1
[  933.758294]  [rtl debug] 30050093 27f0d, signal 1
[  933.779520]  [rtl debug] 3005014f 27f23, signal 1
[  933.791609]  [rtl debug] 3002008d 27f0b, signal 1
[  933.793015]  [rtl debug] 30220067 27f15, signal 1
[  933.799226]  [rtl debug] 300201a7 27f1d, signal 1
[  933.808314]  [rtl debug] 30050115 27e32, signal 1
[  933.813240]  [rtl debug] 3005004b 27f2a, signal 1
[  933.887783]  [rtl debug] 30020170 27e1b, signal 1
[  933.983846]  [rtl debug] 30020170 27e08, signal 1
[  933.986958]  [rtl debug] 3002008d 27e6a, signal 1
[  934.013075]  [rtl debug] 30050115 27e06, signal 1
[  934.040769]  [rtl debug] 300500aa 27f2d, signal 1
[  934.050505]  [rtl debug] 30050070 27e74, signal 1
[  934.078256]  [rtl debug] 300200a4 27e35, signal 1
[  934.115455]  [rtl debug] 30050115 27e2d, signal 1
[  934.143156]  [rtl debug] 300500aa 27f2d, signal 1
[  934.153119]  [rtl debug] 3005011e 27f11, signal 1
[  934.178435]  [rtl debug] 3002006a 27f3f, signal 1
[  934.182284]  [rtl debug] 700200a4 27f38, signal 1
[  934.245545]  [rtl debug] 300500aa 27f07, signal 1
[  934.255291]  [rtl debug] 30050070 27f19, signal 1
[  934.263122]  [rtl debug] 300500b1 27f56, signal 1
[  934.269774]  [rtl debug] 3002006a 27f37, signal 1
[  934.272079]  [rtl debug] 300200a4 27f09, signal 1
[  934.278878]  [rtl debug] 300500b2 27f14, signal 1
[  934.295966]  [rtl debug] 3005006b 27f22, signal 1
[  934.347946]  [rtl debug] 300500aa 27f38, signal 1
[  934.357664]  [rtl debug] 30050070 27f25, signal 1
[  934.370020]  [rtl debug] 300200a4 27f5d, signal 1
[  934.371459]  [rtl debug] 30020069 27f44, signal 1
[  934.391963]  [rtl debug] 30050070 27e23, signal 1
[  934.398341]  [rtl debug] 3005006b 27f53, signal 1
[  934.450319]  [rtl debug] 300500aa 27f47, signal 1
[  934.460050]  [rtl debug] 30050070 27e3d, signal 1
[  934.461697]  [rtl debug] 3002006a 27f5e, signal 1
[  934.463394]  [rtl debug] 3002006a 27f5c, signal 1
[  934.464816]  [rtl debug] 30020069 27f69, signal 1
[  934.482014]  [rtl debug] 30020067 27e51, signal 1
[  934.494346]  [rtl debug] 30050070 27f46, signal 1
[  934.551575]  [rtl debug] 3005007d 27f27, signal 1
[  934.560559]  [rtl debug] 30020069 27f10, signal 1
[  934.562391]  [rtl debug] 3002006a 27f27, signal 1
[  934.582431]  [rtl debug] 3005010d 27f22, signal 1
[  934.596735]  [rtl debug] 30050070 27e06, signal 1
[  934.603122]  [rtl debug] 3005006b 27f4a, signal 1
[  934.642886]  [rtl debug] 3005006d 27e08, signal 1
[  934.653779]  [rtl debug] 3002006a 27e0b, signal 1
[  934.657375]  [rtl debug] 30020067 27f71, signal 1
[  934.667762]  [rtl debug] 3002006b 27f45, signal 1
[  934.672737]  [rtl debug] 30020069 27f34, signal 1
[  934.676975]  [rtl debug] 70050071 27f38, signal 1
[  934.699125]  [rtl debug] 30050070 27f47, signal 1
[  934.752097]  [rtl debug] 300200f9 27e0a, signal 1
[  934.753643]  [rtl debug] 3002006a 27f79, signal 1
[  934.756595]  [rtl debug] 3005007d 27e0c, signal 1
[  934.758060]  [rtl debug] 30020069 27f4f, signal 1
[  934.767387]  [rtl debug] 3002006b 27f12, signal 1
[  934.775403]  [rtl debug] 3005006f 27f40, signal 1
[  934.801523]  [rtl debug] 30050070 27f4e, signal 1
[  934.847670]  [rtl debug] 3005006d 27f6b, signal 1
[  934.889605]  [rtl debug] 3005010d 27f47, signal 1
[  934.903901]  [rtl debug] 30050070 27f33, signal 1
[  934.961145]  [rtl debug] 3005007d 27f26, signal 1
[  934.984144]  [rtl debug] 30050071 27e5b, signal 1
[  934.991995]  [rtl debug] 3005010d 27f59, signal 1
[  935.063539]  [rtl debug] 3005007d 27f2e, signal 1
[  935.086536]  [rtl debug] 30050071 27e59, signal 1
[  935.094391]  [rtl debug] 3005010d 27f28, signal 1
[  935.294095]  [rtl debug] 30050093 27f0d, signal 1
[  935.315383]  [rtl debug] 3005014f 27f2d, signal 1
[  935.344139]  [rtl debug] 30050115 27e2f, signal 1
[  935.349087]  [rtl debug] 3005004b 27f16, signal 1
[  935.362005]  [rtl debug] 30050067 27f23, signal 1
[  935.396495]  [rtl debug] 30050093 27f0a, signal 1
[  935.417782]  [rtl debug] 3005014f 27f42, signal 1
[  935.446524]  [rtl debug] 30050115 27e31, signal 1
[  935.451484]  [rtl debug] 3005004b 27f30, signal 1
[  935.464403]  [rtl debug] 30050067 27f3a, signal 1
[  935.498892]  [rtl debug] 30050093 27f08, signal 1
[  935.520185]  [rtl debug] 3005014f 27f20, signal 1
[  935.548933]  [rtl debug] 30050115 27e44, signal 1
[  935.553878]  [rtl debug] 3005004b 27e2c, signal 1
[  935.566800]  [rtl debug] 70050067 27f3f, signal 1
[  935.601287]  [rtl debug] 30050093 27f0e, signal 1
[  935.622570]  [rtl debug] 3005014f 27f2e, signal 1
[  935.651311]  [rtl debug] 30050115 27e3f, signal 1
[  935.656268]  [rtl debug] 3005004b 27f07, signal 1
[  935.669200]  [rtl debug] 30050067 27e1b, signal 1
[  935.747870]  [rtl debug] 30020170 27e1b, signal 1
[  935.806065]  [rtl debug] 30050093 27e3d, signal 1
[  935.843897]  [rtl debug] 30020170 27e09, signal 1
[  935.856076]  [rtl debug] 30050115 27e05, signal 1
[  935.883769]  [rtl debug] 300500aa 27f48, signal 1
[  935.893513]  [rtl debug] 30050070 27f3f, signal 1
[  935.896431]  [rtl debug] 3005011e 27f51, signal 1
[  935.939984]  [rtl debug] 30020170 27e25, signal 1
[  935.958469]  [rtl debug] 30050115 27e22, signal 1
[  935.996105]  [rtl debug] 3005011e 27f11, signal 1
[  936.035868]  [rtl debug] 30020170 27e30, signal 1
[  936.061206]  [rtl debug] 30050115 27e30, signal 1
[  936.063493]  [rtl debug] 300400fa 27e35, signal 1
[  936.088562]  [rtl debug] 300500aa 27f0a, signal 1
[  936.098300]  [rtl debug] 30050070 27f0d, signal 1
[  936.122085]  [rtl debug] 300500b2 27f17, signal 1
[  936.139005]  [rtl debug] 3005006b 27f4f, signal 1
[  936.234988]  [rtl debug] 30050070 27e34, signal 1
[  936.281135]  [rtl debug] 3005006d 27f4b, signal 1
[  936.293325]  [rtl debug] 300500aa 27f20, signal 1
[  936.303080]  [rtl debug] 30050070 27f4a, signal 1
[  936.337383]  [rtl debug] 30050070 27f4e, signal 1
[  936.343776]  [rtl debug] 3005006b 27f0f, signal 1
[  936.394633]  [rtl debug] 3005007d 27f3b, signal 1
[  936.413651]  [rtl debug] 3005006f 27f0f, signal 1
[  936.439772]  [rtl debug] 30050070 27f36, signal 1
[  936.446175]  [rtl debug] 7005006b 27f35, signal 1
[  936.485926]  [rtl debug] 3005006d 27f11, signal 1
[  936.497014]  [rtl debug] 3005007d 27f3c, signal 1
[  936.542160]  [rtl debug] 30050070 27f0b, signal 1
[  936.599414]  [rtl debug] 3005007d 27f05, signal 1
[  936.618429]  [rtl debug] 3005006f 27f29, signal 1
[  936.622394]  [rtl debug] 30050071 27f13, signal 1
[  936.630241]  [rtl debug] 3005010d 27f10, signal 1
[  936.631779]  [rtl debug] 30050071 27e20, signal 1
[  936.632875]  [rtl debug] 30050062 27f1d, signal 1
[  936.701810]  [rtl debug] 3005007d 27e4f, signal 1
[  936.724798]  [rtl debug] 30050071 27f53, signal 1
[  936.732630]  [rtl debug] 3005010d 27f3d, signal 1
[  936.746931]  [rtl debug] 30050070 27f2e, signal 1
[  936.793086]  [rtl debug] 3005006d 27e67, signal 1
[  936.835028]  [rtl debug] 3005010d 27e4e, signal 1
[  936.906583]  [rtl debug] 3005007d 27f45, signal 1
[  936.937422]  [rtl debug] 3005010d 27f5d, signal 1
[  936.951708]  [rtl debug] 30050070 27f31, signal 1
[  937.158375]  [rtl debug] 3005014f 27f1a, signal 1
[  937.170097]  [rtl debug] 3002002d 27e4c, signal 1
[  937.187158]  [rtl debug] 30050115 27e0b, signal 1
[  937.210086]  [rtl debug] 3002003d 27e03, signal 1
[  937.212782]  [rtl debug] 3002009d 27e05, signal 1
[  937.289552]  [rtl debug] 30050115 7e05, signal 0
[  937.391949]  [rtl debug] 30050115 7e07, signal 0
[  937.444283]  [rtl debug] 30050093 7f30, signal 0
[  937.494324]  [rtl debug] 30050115 7e09, signal 0
[  937.499296]  [rtl debug] 3005004b 7e2e, signal 0
[  937.596719]  [rtl debug] 30050115 7e09, signal 0
[  937.614632]  [rtl debug] 30050067 7f56, signal 0
[  937.699128]  [rtl debug] 30050115 7e08, signal 0
[  937.704082]  [rtl debug] 7005004b 7e47, signal 0
[  937.717030]  [rtl debug] 30050067 7e74, signal 0
[  937.751456]  [rtl debug] 30050093 7e50, signal 0
[  937.801493]  [rtl debug] 30050115 7e05, signal 0
[  937.819417]  [rtl debug] 30050067 7f3d, signal 0
[  937.903915]  [rtl debug] 30050115 7e05, signal 0
[  937.921808]  [rtl debug] 30050067 7f32, signal 0
[  937.956222]  [rtl debug] 30050093 7e44, signal 0
[  938.006276]  [rtl debug] 30050115 7e05, signal 0
[  938.011255]  [rtl debug] 3005004b 7f7c, signal 0
[  938.058622]  [rtl debug] 30050093 7e39, signal 0
[  938.108670]  [rtl debug] 30050115 7e08, signal 0
[  938.110162]  [rtl debug] 3002009d 27e05, signal 1
[  938.113656]  [rtl debug] 3005004b 7f50, signal 0
[  938.119313]  [rtl debug] 300200d7 27e05, signal 1
[  938.161006]  [rtl debug] 30050093 7f3f, signal 0
[  938.211066]  [rtl debug] 30050115 7e0b, signal 0
[  938.216074]  [rtl debug] 3005004b 7f43, signal 0
[  938.313460]  [rtl debug] 30050115 7e06, signal 0
[  938.415870]  [rtl debug] 30050115 7e04, signal 0
[  938.468184]  [rtl debug] 30050093 7e46, signal 0
[  938.518250]  [rtl debug] 30050115 7e05, signal 0
[  938.523219]  [rtl debug] 3005004b 7e3c, signal 0
[  938.570560]  [rtl debug] 30050093 7e3d, signal 0
[  938.622100]  [rtl debug] 30050115 7e06, signal 0
[  938.723041]  [rtl debug] 30050115 7e08, signal 0
[  938.727448]  [rtl debug] 30040200 27e08, signal 1
[  938.775341]  [rtl debug] 30050093 7e47, signal 0
[  938.825417]  [rtl debug] 30050115 7e04, signal 0
[  938.928355]  [rtl debug] 30050115 7e04, signal 0
[  939.030216]  [rtl debug] 30050115 7e05, signal 0
[  939.034576]  [rtl debug] 30040200 27e0b, signal 1
[  939.132606]  [rtl debug] 70050115 7e0d, signal 0
[  939.150521]  [rtl debug] 30050067 7e4e, signal 0
[  939.234977]  [rtl debug] 30050115 7e07, signal 0
[  939.239339]  [rtl debug] 30040200 27e05, signal 1
[  939.287302]  [rtl debug] 30050093 7e46, signal 0
[  939.337373]  [rtl debug] 30050115 7e0e, signal 0
[  939.342352]  [rtl debug] 3005004b 7e4b, signal 0
[  939.440130]  [rtl debug] 30050115 7e06, signal 0
[  939.444323]  [rtl debug] 300401e8 27e09, signal 1
[  939.492075]  [rtl debug] 30050093 7f66, signal 0
[  939.542162]  [rtl debug] 30050115 7e08, signal 0
[  939.543448]  [rtl debug] 30040084 27e0a, signal 1
[  939.644572]  [rtl debug] 30050115 7e09, signal 0
[  939.696865]  [rtl debug] 30050093 7e4f, signal 0
[  939.746941]  [rtl debug] 30050115 7e03, signal 0
[  939.749714]  [rtl debug] 30040131 27e06, signal 1
[  939.850637]  [rtl debug] 30050115 7e06, signal 0
[  939.854321]  [rtl debug] 3005004b 7fba, signal 0
[  939.951775]  [rtl debug] 30050115 7e03, signal 0
[  940.054123]  [rtl debug] 30050115 7e06, signal 0
[  940.056453]  [rtl debug] 300400fa 27e05, signal 1
[  940.156521]  [rtl debug] 30050115 7e06, signal 0
[  940.258923]  [rtl debug] 30050115 7e06, signal 0
[  940.276844]  [rtl debug] 30050067 7e63, signal 0
[  940.361313]  [rtl debug] 30050115 7e09, signal 0
[  940.366281]  [rtl debug] 3005004b 7f3a, signal 0
[  940.463844]  [rtl debug] 30050115 7e0c, signal 0
[  940.467967]  [rtl debug] 300401e8 27e03, signal 1
[  940.566079]  [rtl debug] 30050115 7e05, signal 0
[  940.571064]  [rtl debug] 3005004b 7e32, signal 0
[  940.618385]  [rtl debug] 30050093 7e62, signal 0
[  940.668480]  [rtl debug] 30050115 7e06, signal 0
[  940.720777]  [rtl debug] 70050093 7e43, signal 0
[  940.770867]  [rtl debug] 30050115 7e0b, signal 0
[  940.788833]  [rtl debug] 30050067 7f24, signal 0
[  940.873266]  [rtl debug] 30050115 7e0b, signal 0
[  940.876593]  [rtl debug] 30050180 27e0f, signal 1
[  940.877623]  [rtl debug] 30050066 27e05, signal 1
[  940.891208]  [rtl debug] 30050067 7e35, signal 0
[  940.975663]  [rtl debug] 30050115 7e02, signal 0
[  940.993603]  [rtl debug] 30050067 7e45, signal 0
[  941.078065]  [rtl debug] 30050115 7e04, signal 0
[  941.096003]  [rtl debug] 30050067 7f45, signal 0
[  941.130335]  [rtl debug] 30050093 7e26, signal 0
[  941.180435]  [rtl debug] 30050115 7e05, signal 0
[  941.198396]  [rtl debug] 30050067 7f3f, signal 0
[  941.282821]  [rtl debug] 30050115 7e02, signal 0
[  941.300783]  [rtl debug] 30050067 7e34, signal 0
[  941.335108]  [rtl debug] 30050093 7e51, signal 0
[  941.385226]  [rtl debug] 30050115 7e07, signal 0
[  941.487626]  [rtl debug] 30050115 7e03, signal 0
[  941.505577]  [rtl debug] 30050067 7f54, signal 0
[  941.589992]  [rtl debug] 30050115 7e0a, signal 0
[  941.607958]  [rtl debug] 30050067 7e53, signal 0
[  941.642285]  [rtl debug] 30050093 7e35, signal 0
[  941.692383]  [rtl debug] 30050115 7e05, signal 0
[  941.710361]  [rtl debug] 30050067 7e2e, signal 0
[  941.794772]  [rtl debug] 30050115 7e0c, signal 0
[  941.799066]  [rtl debug] 300401f4 27e05, signal 1
[  941.828890]  [rtl debug] 3032017c 27e04, signal 1
[  941.847050]  [rtl debug] 30050093 7e3c, signal 0
[  941.897176]  [rtl debug] 30050115 7e08, signal 0
[  941.898256]  [rtl debug] 30040060 27e08, signal 1
[  941.949445]  [rtl debug] 30050093 7e4d, signal 0
[  941.999560]  [rtl debug] 70050115 7e0b, signal 0
[  942.002058]  [rtl debug] 3004011d 27e0a, signal 1
[  942.017538]  [rtl debug] 30050067 7f4f, signal 0
[  942.101965]  [rtl debug] 30050115 7e0b, signal 0
[  942.106946]  [rtl debug] 3005004b 7f5e, signal 0
[  942.154231]  [rtl debug] 30050093 7e5f, signal 0
[  942.204337]  [rtl debug] 30050115 7e0c, signal 0
[  942.209040]  [rtl debug] 30040225 27e05, signal 1
[  942.306739]  [rtl debug] 30050115 7e0c, signal 0
[  942.324720]  [rtl debug] 30050067 7f5d, signal 0
[  942.359000]  [rtl debug] 30050093 7e2d, signal 0
[  942.409134]  [rtl debug] 30050115 7e0b, signal 0
[  942.427123]  [rtl debug] 30050067 7e85, signal 0
[  942.511531]  [rtl debug] 30050115 7e00, signal 0
[  942.516239]  [rtl debug] 30040225 27e04, signal 1
[  942.529510]  [rtl debug] 30050067 7e80, signal 0
[  942.613931]  [rtl debug] 30050115 7e04, signal 0
[  942.615156]  [rtl debug] 30040070 27e01, signal 1
[  942.666177]  [rtl debug] 30050093 7e5f, signal 0
[  942.716300]  [rtl debug] 30050115 7e0b, signal 0
[  942.720763]  [rtl debug] 30040207 27e0c, signal 1
[  942.726560]  [rtl debug] 3005004a 27f3f, signal 1
[  942.737453]  [rtl debug] 3005004a 27e63, signal 1
[  942.818689]  [rtl debug] 30050115 7e06, signal 0
[  942.836666]  [rtl debug] 30050067 7f2a, signal 0
[  942.905983]  [rtl debug] 3005004a 27f0c, signal 1
[  942.910324]  [rtl debug] 3005004a 27f0e, signal 1
[  942.914725]  [rtl debug] 3005004a 27f05, signal 1
[  942.919365]  [rtl debug] 3005004a 27f11, signal 1
[  942.921791]  [rtl debug] 30050115 7f56, signal 0
[  942.939092]  [rtl debug] 30050067 7e3b, signal 0
[  942.939942]  [rtl debug] 3005004a 27f3a, signal 1
[  942.944861]  [rtl debug] 7005004a 27f6b, signal 1
[  943.008754]  [rtl debug] 3005004a 27f2e, signal 1
[  943.009873]  [rtl debug] 3005004a 27f40, signal 1
[  943.010727]  [rtl debug] 3005004a 27e5f, signal 1
[  943.023483]  [rtl debug] 30050115 7e0c, signal 0
[  943.025837]  [rtl debug] 300400fa 27e06, signal 1
[  943.125959]  [rtl debug] 30050115 7e08, signal 0
[  943.178128]  [rtl debug] 30050093 7e41, signal 0
[  943.230676]  [rtl debug] 30050115 7e09, signal 0
[  943.280518]  [rtl debug] 30050093 7f45, signal 0
[  943.332073]  [rtl debug] 30050115 7e0c, signal 0
[  943.433188]  [rtl debug] 30050115 7e07, signal 0
[  943.438046]  [rtl debug] 3005004b 7e5f, signal 0
[  943.535452]  [rtl debug] 30050115 7e04, signal 0
[  943.553435]  [rtl debug] 30050067 7f5a, signal 0
[  943.638570]  [rtl debug] 30050115 7e04, signal 0
[  943.642830]  [rtl debug] 3005004b 7f32, signal 0
[  943.740228]  [rtl debug] 30050115 7e07, signal 0
[  943.744676]  [rtl debug] 30040207 27e08, signal 1
[  943.842634]  [rtl debug] 30050115 7e09, signal 0
[  943.945011]  [rtl debug] 30050115 7e05, signal 0
[  944.047386]  [rtl debug] 30050115 7e09, signal 0
[  944.149789]  [rtl debug] 30050115 7e0c, signal 0
[  944.167804]  [rtl debug] 30050067 7f6a, signal 0
[  944.202032]  [rtl debug] 30050093 7f45, signal 0
[  944.252201]  [rtl debug] 30050115 7e06, signal 0
[  944.270198]  [rtl debug] 30050067 7e51, signal 0
[  944.354571]  [rtl debug] 30050115 7e07, signal 0
[  944.459315]  [rtl debug] 30050115 7e04, signal 0
[  944.559407]  [rtl debug] 30050115 7e02, signal 0
[  944.661755]  [rtl debug] 30050115 7e07, signal 0
[  944.679765]  [rtl debug] 30050067 7e70, signal 0
[  944.764157]  [rtl debug] 70050115 7e07, signal 0
[  944.769146]  [rtl debug] 3005004b 7e47, signal 0
[  944.782178]  [rtl debug] 30050067 7f40, signal 0
[  944.868992]  [rtl debug] 30050115 7e05, signal 0
[  944.887294]  [rtl debug] 30050067 7e65, signal 0
[  944.968937]  [rtl debug] 30050115 7e06, signal 0
[  945.071316]  [rtl debug] 30050115 7e08, signal 0
[  945.075614]  [rtl debug] 300401f0 27e07, signal 1
[  945.076314]  [rtl debug] 3005004b 7f57, signal 0
[  945.123543]  [rtl debug] 30050093 7e36, signal 0
[  945.173710]  [rtl debug] 30050115 7e05, signal 0
[  945.225927]  [rtl debug] 30050093 7e28, signal 0
[  945.276103]  [rtl debug] 30050115 7e0a, signal 0
[  945.378481]  [rtl debug] 30050115 7e05, signal 0
[  945.430720]  [rtl debug] 30050093 7e31, signal 0
[  945.480889]  [rtl debug] 30050115 7e09, signal 0
[  945.485891]  [rtl debug] 3005004b 7f42, signal 0
[  945.498893]  [rtl debug] 30050067 7e5f, signal 0
[  945.533101]  [rtl debug] 30050093 7f4f, signal 0
[  945.583279]  [rtl debug] 30050115 7e03, signal 0
[  945.588271]  [rtl debug] 3005004b 7e32, signal 0
[  945.601354]  [rtl debug] 30050067 7f5b, signal 0
[  945.685654]  [rtl debug] 30050115 7e04, signal 0
[  945.703686]  [rtl debug] 30050067 7e60, signal 0
[  945.737877]  [rtl debug] 30050093 7e52, signal 0
[  945.745718]  [rtl debug] 3005004a 27f40, signal 1
[  945.746729]  [rtl debug] 30050056 27f3a, signal 1
[  945.793119]  [rtl debug] 3005004b 7e3b, signal 0
[  945.840268]  [rtl debug] 30050093 7e2c, signal 0
[  945.890432]  [rtl debug] 30050115 7e08, signal 0
[  945.895443]  [rtl debug] 3005004b 7e31, signal 0
[  945.908467]  [rtl debug] 30050067 7e43, signal 0
[  945.972029]  [rtl debug] 7005004a 27f09, signal 1
[  945.984802]  [rtl debug] 30050056 27f07, signal 1
[  945.985751]  [rtl debug] 3005004a 27f11, signal 1
[  945.995460]  [rtl debug] 300400fa 27e04, signal 1
[  945.996552]  [rtl debug] 3005004a 27f0e, signal 1
[  946.010853]  [rtl debug] 30050067 7f54, signal 0
[  946.044068]  [rtl debug] 3005004a 27f4e, signal 1
[  946.095202]  [rtl debug] 30050115 7e05, signal 0
[  946.133918]  [rtl debug] 3005004a 27e39, signal 1
[  946.197624]  [rtl debug] 30050115 7e06, signal 0
[  946.202618]  [rtl debug] 3005004b 7f47, signal 0
[  946.300019]  [rtl debug] 30050115 7e04, signal 0
[  946.352228]  [rtl debug] 30050093 7e1f, signal 0
[  946.402383]  [rtl debug] 30050115 7e06, signal 0
[  946.504785]  [rtl debug] 30050115 7e08, signal 0
[  946.556994]  [rtl debug] 30050093 7e4e, signal 0
[  946.607182]  [rtl debug] 30050115 7e0c, signal 0
[  946.608742]  [rtl debug] 30040070 27e08, signal 1
[  946.709584]  [rtl debug] 30050115 7e0b, signal 0
[  946.811982]  [rtl debug] 30050115 7e08, signal 0
[  946.915476]  [rtl debug] 30050115 7e08, signal 0
[  946.966573]  [rtl debug] 30050093 7e40, signal 0
[  947.016731]  [rtl debug] 30050115 7e09, signal 0
[  947.119459]  [rtl debug] 30050115 7e07, signal 0
[  947.171337]  [rtl debug] 30050093 7f3c, signal 0
[  947.221519]  [rtl debug] 30050115 7e04, signal 0
[  947.273739]  [rtl debug] 30050093 7f3d, signal 0
[  947.323928]  [rtl debug] 30050115 7e02, signal 0
[  947.341959]  [rtl debug] 30050067 7e4c, signal 0
[  947.426319]  [rtl debug] 30050115 7e05, signal 0
[  947.528717]  [rtl debug] 30050115 7e08, signal 0
[  947.580905]  [rtl debug] 30050093 7e1b, signal 0
[  947.631103]  [rtl debug] 70050115 7e04, signal 0
[  947.632092]  [rtl debug] 30040060 27e09, signal 1
[  947.733521]  [rtl debug] 30050115 7e0f, signal 0
[  947.835905]  [rtl debug] 30050115 7e0f, signal 0
[  947.938301]  [rtl debug] 30050115 7e07, signal 0
[  947.943302]  [rtl debug] 3005004b 7f43, signal 0
[  948.040689]  [rtl debug] 30050115 7e08, signal 0
[  948.092870]  [rtl debug] 30050093 7f44, signal 0
[  948.143064]  [rtl debug] 30050115 7e07, signal 0
[  948.245474]  [rtl debug] 30050115 7e0a, signal 0
[  948.297646]  [rtl debug] 30050093 7e53, signal 0
[  948.347877]  [rtl debug] 30050115 7e0b, signal 0
[  948.400038]  [rtl debug] 30050093 7f5f, signal 0
[  948.450266]  [rtl debug] 30050115 7e07, signal 0
[  948.552642]  [rtl debug] 30050115 7e03, signal 0
[  948.655024]  [rtl debug] 30050115 7e05, signal 0
[  948.707215]  [rtl debug] 30050093 7f73, signal 0
[  948.757897]  [rtl debug] 30050115 7e0c, signal 0
[  948.859822]  [rtl debug] 30050115 7e09, signal 0
[  948.864833]  [rtl debug] 3005004b 7e45, signal 0
[  948.912003]  [rtl debug] 30050093 7f48, signal 0
[  948.962199]  [rtl debug] 30050115 7e05, signal 0
[  948.967225]  [rtl debug] 3005004b 7e59, signal 0
[  949.064601]  [rtl debug] 30050115 7e02, signal 0
[  949.082668]  [rtl debug] 30050067 7e8b, signal 0
[  949.167851]  [rtl debug] 30050115 7e08, signal 0
[  949.269542]  [rtl debug] 30050115 7e0b, signal 0
[  949.371779]  [rtl debug] 30050115 7e0d, signal 0
[  949.474161]  [rtl debug] 30050115 7e0c, signal 0
[  949.576567]  [rtl debug] 30050115 7e0d, signal 0
[  949.678945]  [rtl debug] 30050115 7e06, signal 0
[  949.781350]  [rtl debug] 30050115 7e09, signal 0
[  949.799415]  [rtl debug] 70050067 7f66, signal 0
[  949.833512]  [rtl debug] 30050093 7e4e, signal 0
[  949.883738]  [rtl debug] 30050115 7e08, signal 0
[  949.888758]  [rtl debug] 3005004b 7f29, signal 0
[  949.986119]  [rtl debug] 30050115 7e07, signal 0
[  949.988342]  [rtl debug] 300400fa 27e02, signal 1
[  950.088524]  [rtl debug] 30050115 7e07, signal 0
[  950.190904]  [rtl debug] 30050115 7e08, signal 0
[  950.208993]  [rtl debug] 30050067 7f4d, signal 0
[  950.293319]  [rtl debug] 30050115 7e0d, signal 0
[  950.345469]  [rtl debug] 30050093 7f23, signal 0
[  950.395708]  [rtl debug] 30050115 7e0c, signal 0
[  950.447859]  [rtl debug] 30050093 7f3a, signal 0
[  950.498078]  [rtl debug] 30050115 7e04, signal 0
[  950.600496]  [rtl debug] 30050115 7e05, signal 0
[  950.652642]  [rtl debug] 30050093 7e41, signal 0
[  950.703313]  [rtl debug] 30050115 7e04, signal 0
[  950.720962]  [rtl debug] 30050067 7e65, signal 0
[  950.755031]  [rtl debug] 30050093 7e27, signal 0
[  950.805280]  [rtl debug] 30050115 7e02, signal 0
[  950.823365]  [rtl debug] 30050067 7e28, signal 0
[  950.907658]  [rtl debug] 30050115 7e0b, signal 0
[  950.959804]  [rtl debug] 30050093 7e21, signal 0
[  951.010058]  [rtl debug] 30050115 7e08, signal 0
[  951.112442]  [rtl debug] 30050115 7e06, signal 0
[  951.117479]  [rtl debug] 3005004b 7e5d, signal 0
[  951.130544]  [rtl debug] 30050067 7e3f, signal 0
[  951.214852]  [rtl debug] 30050115 7e0a, signal 0
[  951.232947]  [rtl debug] 30050067 7f47, signal 0
[  951.317225]  [rtl debug] 30050115 7e0b, signal 0
[  951.322263]  [rtl debug] 3005004b 7f3d, signal 0
[  951.419643]  [rtl debug] 30050115 7e09, signal 0
[  951.522008]  [rtl debug] 70050115 7e06, signal 0
[  951.574160]  [rtl debug] 30050093 7f31, signal 0
[  951.624412]  [rtl debug] 30050115 7e0a, signal 0
[  951.629443]  [rtl debug] 3005004b 7e31, signal 0
[  951.642503]  [rtl debug] 30050067 7e32, signal 0
[  951.676544]  [rtl debug] 30050093 7e24, signal 0
[  951.731219]  [rtl debug] 30050115 7e0c, signal 0
[  951.744907]  [rtl debug] 30050067 7e57, signal 0
