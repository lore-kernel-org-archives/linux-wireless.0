Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:33401 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaEZFjy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 01:39:54 -0400
Received: by mail-oa0-f49.google.com with SMTP id eb12so7852897oac.22
        for <linux-wireless@vger.kernel.org>; Sun, 25 May 2014 22:39:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALCETrU58grNoqQh5ZutHa8CEt4rqS6FrMWwpC6DaQ0cXqxXhw@mail.gmail.com>
References: <CALCETrUffJLp+AM2-13HEE5+cKtyMMSjJFsJnhcd5kMzebs3NA@mail.gmail.com>
	<CALCETrU58grNoqQh5ZutHa8CEt4rqS6FrMWwpC6DaQ0cXqxXhw@mail.gmail.com>
Date: Mon, 26 May 2014 08:39:53 +0300
Message-ID: <CANUX_P22a2eC0VAw-NCKrnVQRs9t=uy1VHrBF-2dAsW+s=YfUQ@mail.gmail.com> (sfid-20140526_073958_073160_B5E73536)
Subject: Re: Help debugging iwldvm / ath10k stalls
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 26, 2014 at 8:06 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Sun, May 25, 2014 at 10:23 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> I have an old iwldvm station (Intel(R) Centrino(R) Ultimate-N 6300
>> AGN, REV=0x74) and a new ath10k AP (QCA9880-BR4A, I think, as found in
>> the TP-Link Archer C7 vs).  The former is Fedora's 3.14 kernel and the
>> latter is OpenWRT trunk from a few days ago.
>>
>> Every now and then, my connection drops out.  From wireshark on the
>> station, it looks like traffic from the AP to the STA is coming
>> through but traffic from the STA to the AP is not.  I could be wrong
>> here, though.  Nothing is logged in either machine's kernel log.
>> After 5 seconds to a couple minutes, everything starts working again.
>>
>> A couple of Apple devices using the same radio on the same AP seem to work fine.
>>
>> Any advice for debugging this?  I don't know where to start.
>
> I caught one of the stalls with iwlwifi debugging on.  I've attached
> the dmesg.  The stall ended ten seconds or so before the end of this
> trace.  Is this an indication that something's wrong with iwlwifi?
>
> [151258.096091] iwlwifi 0000:03:00.0: U iwlagn_good_plcp_health plcp health thre
> shold 50 delta 96 msecs 103
> [151258.096095] iwlwifi 0000:03:00.0: U iwl_force_rf_reset perform radio reset.
>
Can you please disable powersave?
It seems that it should be disabled by default, but you enabled it?
I might be confused though... Looking again at the code...
