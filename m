Return-Path: <SRS0=Yehs=D2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 957E8C433E7
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Oct 2020 16:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6559721D81
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Oct 2020 16:23:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730565AbgJSQXm convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Oct 2020 12:23:42 -0400
Received: from smtprelay0115.hostedemail.com ([216.40.44.115]:45380 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730442AbgJSQV0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Oct 2020 12:21:26 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 36D2E18029129;
        Mon, 19 Oct 2020 16:20:54 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: rub62_36025de27238
X-Filterd-Recvd-Size: 5430
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Mon, 19 Oct 2020 16:20:49 +0000 (UTC)
Message-ID: <5964d734e81c198421bb7f6516dabcad37c1740d.camel@perches.com>
Subject: Re: [PATCH] wireless: remove unneeded break
From:   Joe Perches <joe@perches.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Christian Lamparter <chunkeey@gmail.com>, trix@redhat.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, alexandre.torgue@st.com,
        ath9k-devel@qca.qualcomm.com, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        linuxwifi@intel.com, chunkeey@googlemail.com, pkshih@realtek.com,
        sara.sharon@intel.com, tova.mussai@intel.com,
        nathan.errera@intel.com, lior2.cohen@intel.com, john@phrozen.org,
        shaul.triebitz@intel.com, shahar.s.matityahu@intel.com,
        Larry.Finger@lwfinger.net, zhengbin13@huawei.com,
        christophe.jaillet@wanadoo.fr, yanaijie@huawei.com,
        saurav.girepunje@gmail.com
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Date:   Mon, 19 Oct 2020 09:20:48 -0700
In-Reply-To: <fb38b96a-b666-1a6d-211d-b79278a8d878@embeddedor.com>
References: <20201019150507.20574-1-trix@redhat.com>
         <b31478ea-979a-1c9c-65db-32325233a715@gmail.com>
         <859112e91c3d221dc599e381dbaecb90dd6467a1.camel@perches.com>
         <fb38b96a-b666-1a6d-211d-b79278a8d878@embeddedor.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2020-10-19 at 10:54 -0500, Gustavo A. R. Silva wrote:
> On 10/19/20 10:21, Joe Perches wrote:
> > On Mon, 2020-10-19 at 17:14 +0200, Christian Lamparter wrote:
> > > On 19/10/2020 17:05, trix@redhat.com wrote:
> > > > From: Tom Rix <trix@redhat.com>
> > > > 
> > > > A break is not needed if it is preceded by a return or goto
> > > > 
> > > > Signed-off-by: Tom Rix <trix@redhat.com>
> > > > diff --git a/drivers/net/wireless/intersil/p54/eeprom.c b/drivers/net/wireless/intersil/p54/eeprom.c
[]
> > > > @@ -870,7 +870,6 @@ int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
> > > >   			} else {
> > > >   				goto good_eeprom;
> > > >   			}
> > > > -			break;
> > > Won't the compiler (gcc) now complain about a missing fallthrough annotation?
> 
> Clang would definitely complain about this.

As far as I can tell, clang 10.0.0 doesn't complain.

This compiles without fallthrough complaint

from make V=1 W=123 CC=clang drivers/net/wireless/intersil/p54/eeprom.o
with -Wimplicit-fallthrough added

$ clang -Wp,-MMD,drivers/net/wireless/intersil/p54/.eeprom.o.d  -nostdinc -isystem /usr/local/lib/clang/10.0.0/include -I./arch/x86/include -I./arch/x86/include/generated  -I./include -I./arch/x86/include/uapi -I./arch/x86/include/generated/uapi -I./include/uapi -I./include/generated/uapi -include ./include/linux/kconfig.h -include ./include/linux/compiler_types.h -D__KERNEL__ -Qunused-arguments -DKBUILD_EXTRA_WARN1 -DKBUILD_EXTRA_WARN2 -DKBUILD_EXTRA_WARN3 -Wall -Wundef -Werror=strict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -fshort-wchar -fno-PIE -Werror=implicit-function-declaration -Werror=implicit-int -Wno-format-security -std=gnu89 -no-integrated-as -Werror=unknown-warning-option -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx -m64 -mno-80387 -mstack-alignment=8 -mtune=generic -mno-red-zone -mcmodel=kernel -DCONFIG_X86_X32_ABI -Wno-sign-compare -fno-asynchronous-unwind-tables -mretpoline-external-thunk -fno-delete-null-pointer-checks -Wno-address-of-packed-mem
 ber -O2 -Wframe-larger-than=2048 -fstack-protector-strong -Wno-format-invalid-specifier -Wno-gnu -mno-global-merge -Wno-unused-const-variable -ftrivial-auto-var-init=pattern -pg -mfentry -DCC_USING_FENTRY -falign-functions=32 -Wdeclaration-after-statement -Wvla -Wno-pointer-sign -Wno-array-bounds -fno-strict-overflow -fno-stack-check -Werror=date-time -Werror=incompatible-pointer-types -fcf-protection=none -Wextra -Wunused -Wno-unused-parameter -Wmissing-declarations -Wmissing-format-attribute -Wmissing-prototypes -Wold-style-definition -Wmissing-include-dirs -Wunused-const-variable -Wno-missing-field-initializers -Wno-sign-compare -Wno-type-limits -Wcast-align -Wdisabled-optimization -Wnested-externs -Wshadow -Wmissing-field-initializers -Wtype-limits -Wunused-macros -Wbad-function-cast -Wcast-qual -Wconversion -Wpacked -Wpadded -Wpointer-arith -Wredundant-decls -Wsign-compare -Wswitch-default     -fsanitize=kernel-address -mllvm -asan-mapping-offset=0xdffffc0000000000  -mllvm -asa
 n-globals=1  -mllvm -asan-instrumentation-with-call-threshold=0  -mllvm -asan-stack=0   --param asan-instrument-allocas=1   -fsanitize-coverage=trace-pc -fsanitize-coverage=trace-cmp -Wimplicit-fallthrough    -DKBUILD_MODFILE='"drivers/net/wireless/intersil/p54/p54common"' -DKBUILD_BASENAME='"eeprom"' -DKBUILD_MODNAME='"p54common"' -c -o drivers/net/wireless/intersil/p54/eeprom.o drivers/net/wireless/intersil/p54/eeprom.c


