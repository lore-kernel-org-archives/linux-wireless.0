Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33604 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753141AbdJaPYE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Oct 2017 11:24:04 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Subject: Re: [v3,1/3] rsi: sdio: add WOWLAN support for S3 suspend state
References: <1509103557-6215-2-git-send-email-amitkarwar@gmail.com>
        <20171030105050.556356028C@smtp.codeaurora.org>
Date: Tue, 31 Oct 2017 17:24:00 +0200
In-Reply-To: <20171030105050.556356028C@smtp.codeaurora.org> (Kalle Valo's
        message of "Mon, 30 Oct 2017 10:50:50 +0000 (UTC)")
Message-ID: <8760avs5m7.fsf@purkki.adurom.net> (sfid-20171031_162411_016523_4A909870)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Amitkumar Karwar <amitkarwar@gmail.com> wrote:
>
>> From: Karun Eagalapati <karun256@gmail.com>
>> 
>> WoWLAN is supported in RS9113 device through GPIO pin2.
>> wowlan config frame is internally sent to firmware in mac80211
>> suspend handler. Also beacon miss threshold and keep-alive time
>> values are increased to avoid un-necessary disconnection with AP.
>> 
>> Signed-off-by: Karun Eagalapati <karun256@gmail.com>
>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>
> 3 patches applied to wireless-drivers-next.git, thanks.
>
> f3ac4e7394a1 rsi: sdio: add WOWLAN support for S3 suspend state
> b6c8d06c8a64 rsi: sdio: Add WOWLAN support for S4 hibernate state
> 063848c3e155 rsi: sdio: Add WOWLAN support for S5 shutdown state

Kbuild bot found build problems with the first patch. (Amit should have
the details in the mail from kbuild bot.) I need a fix by tomorrow
(wednesday) or I need to revert these. Otherwise I cannot submit a pull
request to Dave.

   drivers/net/wireless/rsi/rsi_91x_mac80211.c: In function
   'rsi_wow_map_triggers':
>> drivers/net/wireless/rsi/rsi_91x_mac80211.c:1767:19: error:
>> 'RSI_WOW_ANY' undeclared (first use in this function)
      wow_triggers |= RSI_WOW_ANY;
                      ^~~~~~~~~~~
   drivers/net/wireless/rsi/rsi_91x_mac80211.c:1767:19: note: each
   undeclared identifier is reported only once for each function it
   appears in
>> drivers/net/wireless/rsi/rsi_91x_mac80211.c:1769:19: error:
>> 'RSI_WOW_MAGIC_PKT' undeclared (first use in this function)
      wow_triggers |= RSI_WOW_MAGIC_PKT;
                      ^~~~~~~~~~~~~~~~~
>> drivers/net/wireless/rsi/rsi_91x_mac80211.c:1771:19: error:
>> 'RSI_WOW_DISCONNECT' undeclared (first use in this function)
      wow_triggers |= RSI_WOW_DISCONNECT;
                      ^~~~~~~~~~~~~~~~~~
>> drivers/net/wireless/rsi/rsi_91x_mac80211.c:1774:19: error:
>> 'RSI_WOW_GTK_REKEY' undeclared (first use in this function)
      wow_triggers |= RSI_WOW_GTK_REKEY;
                      ^~~~~~~~~~~~~~~~~
   drivers/net/wireless/rsi/rsi_91x_mac80211.c: In function
   'rsi_mac80211_attach':
>> drivers/net/wireless/rsi/rsi_91x_mac80211.c:1970:7: error: 'struct
>> wiphy' has no member named 'wowlan'
     wiphy->wowlan = &rsi_wowlan_support;
          ^~
   drivers/net/wireless/rsi/rsi_91x_mgmt.c: In function
   'rsi_send_wowlan_request':
>> drivers/net/wireless/rsi/rsi_91x_mgmt.c:1623:12: error:
   'RSI_WOW_GTK_REKEY' undeclared (first use in this function)
      flags |= RSI_WOW_GTK_REKEY;
               ^~~~~~~~~~~~~~~~~
   drivers/net/wireless/rsi/rsi_91x_mgmt.c:1623:12: note: each
   undeclared identifier is reported only once for each function it
   appears in


-- 
Kalle Valo
