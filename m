Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:36513 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751624AbdBXAJq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 19:09:46 -0500
Received: by mail-it0-f54.google.com with SMTP id h10so4253245ith.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2017 16:08:13 -0800 (PST)
Received: from mail-it0-f45.google.com (mail-it0-f45.google.com. [209.85.214.45])
        by smtp.gmail.com with ESMTPSA id d11sm32360itg.1.2017.02.23.16.08.12
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Feb 2017 16:08:12 -0800 (PST)
Received: by mail-it0-f45.google.com with SMTP id h10so4252973ith.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2017 16:08:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170223120211.22358-1-andrew.zaborowski@intel.com>
References: <20170223120211.22358-1-andrew.zaborowski@intel.com>
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Date: Fri, 24 Feb 2017 01:08:12 +0100
Message-ID: <CAOq732LiwZ13wVuB+wvk6nOCpY+oq=KWhcY1Au2zpcGSWsZ3uA@mail.gmail.com> (sfid-20170224_010957_854416_31DD49EC)
Subject: Re: [PATCH 1/2] mac80211_hwsim: Make sure NEW_RADIO contains final name
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 February 2017 at 13:02, Andrew Zaborowski
<andrew.zaborowski@intel.com> wrote:
> ieee80211_alloc_hw_nm will validate the requested name (if any) before
> creating the new device and may use a name different from the one
> requested rather than fail.  Make sure the HWSIM_CMD_NEW_RADIO
> event/response generated has the final name or userspace will receive
> the wrong name.  Note that mac80211_hwsim_new_radio may now modify
> params.

Also related to this I find that the HWSIM_ATTR_RADIO_NAME attributes
emitted contain the name string and are exactly of the right length
while the HWSIM_ATTR_RADIO_NAME attributes received by the kernel are
assumed to be NUL-terminated.  Is there a guarantee that a 0-byte
follows an attribute, or should this be changed for consistency?

Best regards
