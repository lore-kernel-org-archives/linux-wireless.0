Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28659 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbcH3Emf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Aug 2016 00:42:35 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Eric Bentley <eric.bentley@lairdtech.com>
CC: "ath6kl@lists.infradead.org" <ath6kl@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Allow the radio to report 0 dbm txpower without timing
 out
Date: Tue, 30 Aug 2016 04:42:26 +0000
Message-ID: <87d1kqj2a6.fsf@kamboji.qca.qualcomm.com> (sfid-20160830_064247_617327_4A43C823)
References: <1472531450-19115-1-git-send-email-eric.bentley@lairdtech.com>
In-Reply-To: <1472531450-19115-1-git-send-email-eric.bentley@lairdtech.com>
        (Eric Bentley's message of "Tue, 30 Aug 2016 00:30:50 -0400")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eric Bentley <eric.bentley@lairdtech.com> writes:

> The ath6kl driver attempts to get the txpower from the radio by first
> clearing the existing stored value and then watching the value to become
> non-zero. However, this value is in dbm and 0 is a valid value.
>
> APs allow setting client power to values from -127..127. However, The rad=
io
> is not capable of setting values less then 0 and so will report txpower
> as 0 for both negative and 0 client power.
>
> The 6004 defaults to 63dbm which is then limited by regulatory and
> hardware limits with max of 18dbm (6003 max is 16dbm), therefore we can
> use values larger then this to be able to determine when the value has
> been updated.
>
> Set the value to a nonsensical value (255) and wait for it to change.

Please prefix the title with "ath6kl: ". Also Signed-off-by is missing.

In the title you mention a bit about the bug you are fixing, but it
would be useful to describe more about it in the commit log. From user's
point of view, how did ath6kl behave before your patch and how will it
change after your patch?

--=20
Kalle Valo=
