Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41554 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3IJJLl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 05:11:41 -0400
Received: by mail-pa0-f47.google.com with SMTP id kl13so7414288pab.6
        for <linux-wireless@vger.kernel.org>; Tue, 10 Sep 2013 02:11:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1378795636.4799.44.camel@porter.coelho.fi>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
 <1378218848-7853-6-git-send-email-eliad@wizery.com> <1378795636.4799.44.camel@porter.coelho.fi>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 10 Sep 2013 11:11:25 +0200
Message-ID: <CA+XVXfc6RG1BngT_+doiOUhtYAgnG9Q0-oXns-ckJkU7XhE5ag@mail.gmail.com> (sfid-20130910_111144_759584_DDB10254)
Subject: Re: [PATCH 06/12] wlcore: send EAPOL frames with voice priority
To: Luca Coelho <luca@coelho.fi>
Cc: Eliad Peller <eliad@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 10, 2013 at 9:47 AM, Luca Coelho <luca@coelho.fi> wrote:
> On Tue, 2013-09-03 at 17:34 +0300, Eliad Peller wrote:
>> From: Igal Chernobelsky <igalc@ti.com>
>>
>> Send EAPOL frames with voice priority by setting TX_HW_ATTR_EAPOL_FRAME
>> new bit in tx attribute. Sending EAPOL with voice priority fixes
>> re-key timeout during heavy traffic issue.
>>
>> Signed-off-by: Igal Chernobelsky <igalc@ti.com>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>
> This seems to be the same problem that Ben had and debugged by himself
> [1].  Fixing this in hostapd/wpa_supplicant seems more appropriate?
>
> This patch seems to take an advantage of some sort of hack in the
> firmware that will change the priority by itself when the
> TX_HW_ATTR_EAPOL_GRAME bit is set.  If we have a good reason to use this
> patch, we need to take care of the firmware version as well.  This
> probably doesn't work with the latest published firmware.
>
> [1] http://mid.gmane.org/522E18E5.1020503@candelatech.com

I believe he only fixed one mode (AP - hostapd) but not the other (GO
- wpa_supplicant). Anyway that's what we tested at the time.

Anyway marking it as this level doesn't do any harm. You're right
about the FW version though - it should be upstreamed first.

Arik
