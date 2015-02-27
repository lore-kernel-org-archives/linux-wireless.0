Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:21053 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbbB0Hmz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2015 02:42:55 -0500
Message-ID: <54F01FF9.50108@linux.intel.com> (sfid-20150227_084323_246700_DFEF8F73)
Date: Fri, 27 Feb 2015 15:42:49 +0800
From: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>,
	Kalle Valo <kvalo@codeaurora.org>,
	"brudley@broadcom.com" <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>,
	"meuleman@broadcom.com" <meuleman@broadcom.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"pieterpg@broadcom.com" <pieterpg@broadcom.com>,
	"hdegoede@redhat.com" <hdegoede@redhat.com>,
	"wens@csie.org" <wens@csie.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] brcmfmac: avoid duplicated suspend/resume operation
References: <54DC1D7D.5050407@linux.intel.com> <54E0072D.3020802@linux.intel.com> <063D6719AE5E284EB5DD2968C1650D6D1CAE430C@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1CAE430C@AcuExch.aculab.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 2015/2/16 17:50, David Laight wrote:
>>> WiFi chip has 2 SDIO functions, and PM core will trigger
>>> twice suspend/resume operations for one WiFi chip to do
>>> the same things. This patch avoid this case.
> Do you want to suspend on the first or last request?
>
> In general it might be that one function is in use and
> something wants to suspend the other (as inactive).
>
> If they suspend together you might need to pretend the
> first function is suspended but only do the real power-saving
> device suspend when all the functions have been suspended.
I was in Chinese new-year vacation these few days. So sorry for late response.

Suspend/Resume entry functions of brcmfmac driver does not differentiate between two functions, performs the same operations instead.


Thanks,
Zhonghui
>
> 	David
>
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{��*ޕ�,�{ay�ʇڙ�,j��f���h���z��w������j:+v���w�j�m��������zZ+�����ݢj"��!tml=

