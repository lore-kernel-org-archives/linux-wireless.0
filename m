Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:4970 "EHLO
        alexa-out-lv-02.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752270AbdHHSpi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 14:45:38 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Lior David <liord@codeaurora.org>
CC: qca_merez <qca_merez@qca.qualcomm.com>,
        QCA_gidons <QCA_gidons@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        wil6210 <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH v4 10/10] wil6210: make debugfs compilation optional
Date: Tue, 8 Aug 2017 18:43:08 +0000
Message-ID: <87inhxj3yc.fsf@kamboji.qca.qualcomm.com> (sfid-20170808_204543_426672_0DB840CC)
References: <1501787302-22885-1-git-send-email-qca_merez@qca.qualcomm.com>
        <1501787302-22885-11-git-send-email-qca_merez@qca.qualcomm.com>
        <87r2wmianc.fsf@kamboji.qca.qualcomm.com>
        <51c889b0-de30-ea32-13d7-264f94eed158@codeaurora.org>
In-Reply-To: <51c889b0-de30-ea32-13d7-264f94eed158@codeaurora.org> (Lior
        David's message of "Tue, 8 Aug 2017 20:32:52 +0300")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lior David <liord@codeaurora.org> writes:

> On 8/8/2017 2:03 PM, Kalle Valo wrote:
>> Maya Erez <qca_merez@qca.qualcomm.com> writes:
>>=20
>>> From: Gidon Studinski <qca_gidons@qca.qualcomm.com>
>>>
>>> Since debugfs is a kernel configuration option, enable the driver to
>>> compile without debugfs.
>>>
>>> Signed-off-by: Gidon Studinski <qca_gidons@qca.qualcomm.com>
>>> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>

[...]

>>> +#if defined(CONFIG_DEBUG_FS)
>>>  int wil6210_debugfs_init(struct wil6210_priv *wil);
>>>  void wil6210_debugfs_remove(struct wil6210_priv *wil);
>>> +#else
>>> +static inline int wil6210_debugfs_init(struct wil6210_priv *wil) { ret=
urn 0; }
>>> +static inline void wil6210_debugfs_remove(struct wil6210_priv *wil) {}
>>> +#endif
>>=20
>> I was thinking more that should we have CONFIG_WIL6210_DEBUGFS, just
>> like we have CONFIG_ATH10K_DEBUGFS and CONFIG_ATH9K_DEBUGFS? This way it
>> can be controlled per driver if debugfs interface is available or not.
>>=20
> Hi Kalle, I am answering instead of Maya, she is currently on holiday.
> We will consider this and resend the patch.

Ok, no rush.

> Is it possible to apply the other patches in the v4 series except this on=
e and
> patch #2 (the scan timeout module parameter)?

I was actually planning to do exactly that. I was just waiting for
kbuild bot results because I had to fix a trivial conflict after
removing patch 2.

--=20
Kalle Valo=
