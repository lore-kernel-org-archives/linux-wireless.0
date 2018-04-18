Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:41959 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751305AbeDROqN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 10:46:13 -0400
Received: from [192.168.178.68] ([188.97.189.171]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LegAQ-1eeiBJ2xOI-00qV7F for
 <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2018 16:46:11 +0200
From: Bernhard Gabler <Bernhard_Gabler@web.de>
Subject: ath confusing log message "country IE"
To: Linux-Wireless mailing list <linux-wireless@vger.kernel.org>
Message-ID: <660b1538-0ccb-8f1a-ebe0-632b0e14a46b@web.de> (sfid-20180418_164617_845735_F93BD4F7)
Date: Wed, 18 Apr 2018 16:46:11 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

would it be possible to re-write the log message from
    "regdomain ... dynamically updated by country IE"
in a less ambiguous way, e.g. to:
    "regdomain ... dynamically updated by country-IE"
    "regdomain ... dynamically updated by country information element"
, please?

To the occasional reader, the following system log messages seem to 
convey that
  -  "DE" (Germany) was intended to be used, but
  -  "IE" (Ireland) was configured as regdomain.

     [ 2723.739071] ath: EEPROM regdomain: 0x8114
     [ 2723.739072] ath: EEPROM indicates we should expect a country code
     [ 2723.739073] ath: doing EEPROM country->regdmn map search
     [ 2723.739074] ath: country maps to regdmn code: 0x37
     [ 2723.739075] ath: Country alpha2 being used: DE
     [ 2723.739076] ath: Regpair used: 0x37
     [ 2723.739077] ath: regdomain 0x8114 dynamically updated by country IE

Only after intense googling, I now know that IE stands for "information 
element", not for Ireland. But this is not obvious at. To prevent others 
from confusion and wasting time on a non-problem, could please someone 
rewrite the log message?

Regards,
Bernhard

PS: The example log is from a machine with "Qualcomm Atheros QCA6174" 
but I fancy other drivers may show same/similar messages.
