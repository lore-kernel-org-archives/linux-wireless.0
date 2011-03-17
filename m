Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33887 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab1CQSrJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 14:47:09 -0400
Received: by iwn34 with SMTP id 34so3112208iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2011 11:47:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinVaFcD8L9kOjPW-y7pVxR0ReHsLBy6=SG=8OJC@mail.gmail.com>
References: <1298635263-4883-1-git-send-email-vnatarajan@atheros.com>
 <AANLkTi=GPbB6EbWCGGjRupwsBLMaVt=ymO5hb9eU-Q+r@mail.gmail.com> <AANLkTinVaFcD8L9kOjPW-y7pVxR0ReHsLBy6=SG=8OJC@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 17 Mar 2011 11:46:33 -0700
Message-ID: <AANLkTinPO7AFbtU2r4_8u99Vc7XQOYJ4==q+mWMtsapU@mail.gmail.com>
Subject: Re: [PATCH 1/3] ath9k_hw: Fix pcie_serdes setting for AR9485 1.1 version.
To: Vivek Natarajan <vnatarajan@atheros.com>,
	Sarvesh Shrivastava <sarvesh.shrivastava@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jack Lee <jack.lee@atheros.com>,
	Carl Huang <carl.huang@atheros.com>,
	David Quan <david.quan@atheros.com>,
	Nael Atallah <nael.atallah@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 17, 2011 at 11:38 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Wed, Mar 16, 2011 at 5:04 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Fri, Feb 25, 2011 at 4:01 AM, Vivek Natarajan <vnatarajan@atheros.com> wrote:
>>> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
>>
>> Was this a stable fix? If not why not?
>
> This certainly smells like a stable fix

OK so AR9485 1.1 support did not make it into 2.6.38, and this fix is
applicable only to AR9485 1.1 so the patch in question is not
applicable to stable. The 2.6.38 release however does have AR9485 1.0
support. Will we have any devices in the field with AR9485 1.0 ? Did
that revision not require a similar fix? On 2.6.38 and on linux-next I
see we have for 1.0:

                /* Awake Setting */

                INIT_INI_ARRAY(&ah->iniPcieSerdes,
                                ar9485_1_0_pcie_phy_pll_on_clkreq_disable_L1,

ARRAY_SIZE(ar9485_1_0_pcie_phy_pll_on_clkreq_disable_L1),
                                2);

                /* Sleep Setting */

                INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
                                ar9485_1_0_pcie_phy_pll_on_clkreq_enable_L1,

ARRAY_SIZE(ar9485_1_0_pcie_phy_pll_on_clkreq_enable_L1),
                                2);

  Luis
