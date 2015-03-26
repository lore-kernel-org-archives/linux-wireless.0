Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailsrv5-bkp2.dondominio.net ([37.152.88.47]:34008 "EHLO
	mailsrv5.dondominio.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751082AbbCZJdP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2015 05:33:15 -0400
Message-ID: <5513D29E.2080601@aoifes.com> (sfid-20150326_103319_367646_B2AE9C73)
Date: Thu, 26 Mar 2015 10:34:22 +0100
From: Jose Antonio Delgado Alfonso <jose.delgado@aoifes.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: Dynamic channel Access
References: <CADxDmp50X2XnBjfk5qJKRH-n=1Cwagmjb_XyD+RJ4AgpPh-kjQ@mail.gmail.com> <CAEFj985wmiPwnF7rM1qCcO2K3X2yC_onO0AAMfm=9ytwpChzgg@mail.gmail.com> <etPan.542e8df5.6b8b4567.117@Okhwanui-Mac-mini.local> <55128DF0.6010109@aoifes.com> <5512D58B.6030204@aoifes.com> <CA+BoTQkabNNya7QW3GukcCoRcm9AfL2Vd2STMQSs9y0wRuivgA@mail.gmail.com>
In-Reply-To: <CA+BoTQkabNNya7QW3GukcCoRcm9AfL2Vd2STMQSs9y0wRuivgA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26/03/15 07:30, Michal Kazior wrote:
> On 25 March 2015 at 16:34, Jose Antonio Delgado Alfonso
> <jose.delgado@aoifes.com> wrote:
>> Hi all,
>>
>> I would like to ask Qualcomm's collaborators about this topic.
>>
>> We are trying to certify a AP product which uses QCA988x radio module.
>> We are using the ath10k driver (kernel v3.17.8) and firmware from Ben
>> Greear. We are trying to pass the Dynamic Channel test, which consists
>> in setting the radio at 80MHz and, at the same time, setting other
>> signal in the secondary channel. So far, the radio module does not
>> reduce the bandwidth and remains transmitting at 80MHz.
>>
>> Please, Does someone know if Dynamic Channel Access is really supported
>> by ath10k driver in newest kernel versions?
> You haven't really defined what kind of "other signal" you set up.
> ath10k sets/enables dynamic_bw wmi parameter in ath10k_start(). From
> what I know dynamic_bw does enable fw/hw to downgrade traffic from
> 80MHz to 40MHz in case there's other 802.11 traffic on the subband
> happening at least on 10.1.467 - not sure about non-802.11 traffic. I
> suppose newer firmware revisions do that too. I'm not sure about
> 999.999.0.636 though.
>
>
> Michał
>
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
I tested with other AP and also with a signal generator emitting a flat
noise of 20 MHz continuously.

I will check how function ath10k_start is implemented in my kernel tree
and if that parameter is really enabled on my setup.

Thanks.

Jose A. Delgado
