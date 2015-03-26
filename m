Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:38409 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbbCZGbB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2015 02:31:01 -0400
Received: by wibgn9 with SMTP id gn9so70921164wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2015 23:31:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5512D58B.6030204@aoifes.com>
References: <CADxDmp50X2XnBjfk5qJKRH-n=1Cwagmjb_XyD+RJ4AgpPh-kjQ@mail.gmail.com>
	<CAEFj985wmiPwnF7rM1qCcO2K3X2yC_onO0AAMfm=9ytwpChzgg@mail.gmail.com>
	<etPan.542e8df5.6b8b4567.117@Okhwanui-Mac-mini.local>
	<55128DF0.6010109@aoifes.com>
	<5512D58B.6030204@aoifes.com>
Date: Thu, 26 Mar 2015 07:30:59 +0100
Message-ID: <CA+BoTQkabNNya7QW3GukcCoRcm9AfL2Vd2STMQSs9y0wRuivgA@mail.gmail.com> (sfid-20150326_073106_561490_1FD54987)
Subject: Re: Dynamic channel Access
From: Michal Kazior <michal.kazior@tieto.com>
To: Jose Antonio Delgado Alfonso <jose.delgado@aoifes.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 March 2015 at 16:34, Jose Antonio Delgado Alfonso
<jose.delgado@aoifes.com> wrote:
> Hi all,
>
> I would like to ask Qualcomm's collaborators about this topic.
>
> We are trying to certify a AP product which uses QCA988x radio module.
> We are using the ath10k driver (kernel v3.17.8) and firmware from Ben
> Greear. We are trying to pass the Dynamic Channel test, which consists
> in setting the radio at 80MHz and, at the same time, setting other
> signal in the secondary channel. So far, the radio module does not
> reduce the bandwidth and remains transmitting at 80MHz.
>
> Please, Does someone know if Dynamic Channel Access is really supported
> by ath10k driver in newest kernel versions?

You haven't really defined what kind of "other signal" you set up.
ath10k sets/enables dynamic_bw wmi parameter in ath10k_start(). From
what I know dynamic_bw does enable fw/hw to downgrade traffic from
80MHz to 40MHz in case there's other 802.11 traffic on the subband
happening at least on 10.1.467 - not sure about non-802.11 traffic. I
suppose newer firmware revisions do that too. I'm not sure about
999.999.0.636 though.


Michał
