Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42756 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab2I2OW4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2012 10:22:56 -0400
Received: by pbbrr4 with SMTP id rr4so6255438pbb.19
        for <linux-wireless@vger.kernel.org>; Sat, 29 Sep 2012 07:22:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120929093118.GA3022@ritirata.org>
References: <1348761132-8344-1-git-send-email-mohammed@qca.qualcomm.com>
	<20581.2614.43943.601901@gargle.gargle.HOWL>
	<50652E56.10303@qca.qualcomm.com>
	<20581.32544.134606.56158@gargle.gargle.HOWL>
	<20120929093118.GA3022@ritirata.org>
Date: Sat, 29 Sep 2012 07:22:55 -0700
Message-ID: <CAJ-Vmo=DumyyrJ-GEwLryYZgeyb0_SgM7mkfvG_hLgwvPsK3qg@mail.gmail.com> (sfid-20120929_162332_048033_00F73A0A)
Subject: Re: [RFC 1/2] ath9k_htc: Advertize allowed vif combinations
From: Adrian Chadd <adrian@freebsd.org>
To: Antonio Quartulli <ordex@autistici.org>
Cc: Sujith Manoharan <c_manoha@qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 September 2012 02:31, Antonio Quartulli <ordex@autistici.org> wrote:
> On Fri, Sep 28, 2012 at 04:12:40 +0530, Sujith Manoharan wrote:
>> Mohammed Shafi Shajakhan wrote:
>> > oh yeah, you are saying that we will have some issues with IBSS
>> > coexistence with other modes because of TSF sync.
>>
>> Yes, this is a problem.
>
> Is there anyway to overcome this problem? Can we bind the single TSF to multiple
> virtualTSF? or must the device somehow support us?

Just total conjecture here, but the problem with TSF mangaement and
multiple VIFs will likely show up the most when you start doing NIC
power save operation.

ISTR there's something which causes the NIC to not queue TX frames
around the beacon interval, to let the AP TX. That will likely be
based on around TSF sync.

So sure, you could implement some form of software TSF but it won't
help for the MAC supported stuff like beacon TX and power save / sleep
state handling.



Adrian
