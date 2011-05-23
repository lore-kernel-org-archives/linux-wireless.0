Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38710 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab1EWUZ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 16:25:58 -0400
Received: by gyd10 with SMTP id 10so2281829gyd.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2011 13:25:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DDABEE9.9090608@candelatech.com>
References: <4DD6E9B5.3020905@candelatech.com> <BANLkTindTMFNNpyNpNndhhGv7qWB5_haGQ@mail.gmail.com>
 <4DDA913B.1060002@candelatech.com> <4DDAA9ED.1050606@candelatech.com>
 <4DDAACF3.3050705@candelatech.com> <BANLkTimizNePq-GFsOYxNtfDNLc8kqjJFw@mail.gmail.com>
 <4DDABEE9.9090608@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 23 May 2011 13:25:38 -0700
Message-ID: <BANLkTineDDcWvmr8M5hp-=b0LDRamZyovQ@mail.gmail.com> (sfid-20110523_222602_939085_D7192174)
Subject: Re: ath9k 9380: All 5Ghz channels flagged as passive-scanning
To: Ben Greear <greearb@candelatech.com>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 23, 2011 at 1:09 PM, Ben Greear <greearb@candelatech.com> wrote:
> Makes it basically useless as a 5Ghz AP though, eh?

Um yup. The card is a world roaming card... not an AP card. For AP
mode of functionality vendors have to go through a regulatory test
specific to 3 regions, and depending on which region they get
certification for they will have then programmed in the values
required for regulatory on the CTLs. The EEPROM would be configured
for the region the card was being tested for.

> Guess it's time to go find a hack to over-ride eeprom
> settings :(

Good luck with support from anyone for any further questions ;) [1].
The real solution to these issues is for regulatory agencies to start
warming up to the idea about dynamic regulatory selection but for this
you will also then need to ensure each card gets properly tested for
each regulatory region -- or we'd have to restrict the card to work in
beaconing mode only for the CTLs it was tested for.

Anyway, this will take some time but it is the path I think we need to
take. In the meantime the only thing you can do with world roaming
cards then is to scan prior to using a beaconing mode of operation.
That will enable beacon hints [2] which will enable beaconing on
non-DFS channels.

[1] http://wireless.kernel.org/en/developers/Regulatory/CRDA#Helping_compliance_by_allowing_to_change_regulatory_domains
[2] http://wireless.kernel.org/en/developers/Regulatory/processing_rules#Beacon_hints

  Luis
