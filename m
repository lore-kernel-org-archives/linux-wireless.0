Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51030 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab1AJUXP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 15:23:15 -0500
Received: by eye27 with SMTP id 27so8811367eye.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jan 2011 12:23:14 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 10 Jan 2011 15:23:14 -0500
Message-ID: <AANLkTikj+40TksokdnAKzXnBi7CBE5GO4BEKoaxQG79D@mail.gmail.com>
Subject: ath9k_hw_check_alive routine
From: Bill Jordan <bjordan@rajant.com>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This routine is failing a lot on my AR9160. The ((reg & 0x7E7FFFEF) ==
0x00702400) test is the one that always fails. There is no debug
messages in this path, so it may not be obvious whether others are
experiencing the problem.

This forces ath9k_tasklet to reset the hardware. If I increase the
count to 500, I can eliminate most of the resets, so the hardware
isn't really hung. However, it sometimes takes over 25 milliseconds
before the test condition passes.

I don't have specs for the radio, and the numeric constants aren't
very useful, so I can't tell what condition we are waiting for or why.

Can someone with a spec shed some light on this problem?

bool ath9k_hw_check_alive(struct ath_hw *ah)
{
	int count = 50;
	u32 reg;

	if (AR_SREV_9285_10_OR_LATER(ah))
		return true;

	do {
		reg = REG_READ(ah, AR_OBS_BUS_1);

		if ((reg & 0x7E7FFFEF) == 0x00702400)
			continue;

		switch (reg & 0x7E000B00) {
		case 0x1E000000:
		case 0x52000B00:
		case 0x18000B00:
			continue;
		default:
			return true;
		}
	} while (count-- > 0);
	return false;
}

Thanks,
Bill Jordan
