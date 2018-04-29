Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:43858 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753584AbeD2SaG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Apr 2018 14:30:06 -0400
Received: by mail-io0-f175.google.com with SMTP id t23-v6so7939135ioc.10
        for <linux-wireless@vger.kernel.org>; Sun, 29 Apr 2018 11:30:05 -0700 (PDT)
Received: from mail-it0-f42.google.com (mail-it0-f42.google.com. [209.85.214.42])
        by smtp.gmail.com with ESMTPSA id k92-v6sm2972115iod.22.2018.04.29.11.30.04
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Apr 2018 11:30:05 -0700 (PDT)
Received: by mail-it0-f42.google.com with SMTP id f65-v6so3526357itd.3
        for <linux-wireless@vger.kernel.org>; Sun, 29 Apr 2018 11:30:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87in8b8ooy.fsf@purkki.adurom.net>
References: <20180428014732.4018-1-andrew.zaborowski@intel.com> <87in8b8ooy.fsf@purkki.adurom.net>
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Date: Sun, 29 Apr 2018 20:30:04 +0200
Message-ID: <CAOq732JPfbJWyR0RROY-t67p7dOuoHoHS6eaMrZ1j39F1Q0zmg@mail.gmail.com> (sfid-20180429_203012_488292_838F025C)
Subject: Re: [PATCH] nl80211: Reject disconnect commands except from conn_owner
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 April 2018 at 15:07, Kalle Valo <kvalo@codeaurora.org> wrote:
> Andrew Zaborowski <andrew.zaborowski@intel.com> writes:
>> Reject NL80211_CMD_DISCONNECT, NL80211_CMD_DISASSOCIATE,
>> NL80211_CMD_DEAUTHENTICATE and NL80211_CMD_ASSOCIATE commands
>> from clients other than the connection owner set in the connect,
>> authenticate or associate commands, if it was set.
>>
>> The main point of this check is to prevent chaos when two processes
>> try to use nl80211 at the same time, it's not a security measure.
>> The same thing should possibly be done for JOIN_IBSS/LEAVE_IBSS and
>> START_AP/STOP_AP.
>
> s-o-b missing.

True, thanks.  Also I was going to send this as an RFC.

Best regards
