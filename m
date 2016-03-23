Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:38270 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbcCWG14 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2016 02:27:56 -0400
Received: by mail-wm0-f43.google.com with SMTP id l68so9884682wml.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Mar 2016 23:27:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56F1E003.4000900@codeaurora.org>
References: <201603230727.oL9ihH6E%fengguang.wu@intel.com>
	<56F1E003.4000900@codeaurora.org>
Date: Wed, 23 Mar 2016 07:27:54 +0100
Message-ID: <CA+BoTQneAJJ=9L4XZYJVxxPXwbH3x_d6ExJii70tG3YJRxPicw@mail.gmail.com> (sfid-20160323_072800_266700_B8C419CF)
Subject: Re: [PATCH v2] ath10k: parse Rx MAC timestamp in mgmt frame for FW 10.4
From: Michal Kazior <michal.kazior@tieto.com>
To: Peter Oh <poh@codeaurora.org>
Cc: kbuild test robot <lkp@intel.com>, Peter Oh <poh@qca.qualcomm.com>,
	kbuild-all@01.org,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 March 2016 at 01:14, Peter Oh <poh@codeaurora.org> wrote:
>
> On 03/22/2016 04:14 PM, kbuild test robot wrote:
>>
>> Hi Peter,
>>
>> [auto build test WARNING on wireless-drivers-next/master]
>> [also build test WARNING on v4.5 next-20160322]
>> [if your patch is applied to the wrong git tree, please drop us a note to
>> help improving the system]
>>
>> url:
>> https://github.com/0day-ci/linux/commits/Peter-Oh/ath10k-parse-Rx-MAC-timestamp-in-mgmt-frame-for-FW-10-4/20160323-064843
>> base:
>> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git
>> master
>> config: x86_64-randconfig-x000-201612 (attached as .config)
>> reproduce:
>>          # save the attached .config to linux build tree
>>          make ARCH=x86_64
>>
>> All warnings (new ones prefixed by >>):
>>
>>     In file included from include/linux/linkage.h:4:0,
>>                      from include/linux/kernel.h:6,
>>                      from include/linux/skbuff.h:17,
>>                      from drivers/net/wireless/ath/ath10k/wmi.c:18:
>>     drivers/net/wireless/ath/ath10k/wmi.c: In function
>> 'ath10k_wmi_10_4_op_pull_mgmt_rx_ev':
>>     drivers/net/wireless/ath/ath10k/wmi.c:2236:33: error:
>> 'WMI_RX_STATUS_EXT_INFO' undeclared (first use in this function)
>
> it seems the warning is false report. I could see WMI_RX_STATUS_EXT_INFO is
> defined in wmi.h.
> Moreover this check command doesn't claim any warning/error make
> M=drivers/net/wireless/ath/ath10k C=2 CF="-D__CHECK_ENDIAN__"

I think the problem here is buildbot tested your patch against
wireless-drivers-next tree which doesn't include the macro yet. The
macro is in ath.git though.


Michał
