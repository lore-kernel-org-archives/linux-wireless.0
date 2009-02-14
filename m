Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f222.google.com ([209.85.217.222]:44046 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbZBNDYa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 22:24:30 -0500
Received: by gxk22 with SMTP id 22so1445079gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2009 19:24:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <499637AB.9010301@erley.org>
References: <1925ef8a0902130015o6df0c962n3fe05ec420d0aef@mail.gmail.com>
	 <43e72e890902130023w3c192b04r3a41b4643eedb530@mail.gmail.com>
	 <1925ef8a0902130454i7b72a7fftb13cc6b77413b70c@mail.gmail.com>
	 <43e72e890902131449n153b606fne9a6dba1af071915@mail.gmail.com>
	 <49962FC9.2040406@erley.org>
	 <43e72e890902131908n3ca09f43w9ac5165b3f03ac66@mail.gmail.com>
	 <499637AB.9010301@erley.org>
Date: Fri, 13 Feb 2009 19:24:29 -0800
Message-ID: <43e72e890902131924i6782bb6ch7ad0d02a6898cc0e@mail.gmail.com> (sfid-20090214_042435_204342_ED7AF6AB)
Subject: Re: compat-wireless with CONFIG_MAC80211disabled
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: pat-lkml <pat-lkml@erley.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 13, 2009 at 7:16 PM, pat-lkml <pat-lkml@erley.org> wrote:
> Luis R. Rodriguez wrote:
>  >> Is there interest in a patch allowing you to
>>> set something like FORCE=y on the CLI to override these patches?
>>
>> Do you have CONFIG_NET_DMA?
>> If not do you have CONFIG_NETWORK_SECMARK?
>>
>> It'd be interesting to see what net core is doing due to the rape and
>> it'd be even more interesting if we can determine the rape is allowed
>> during certain circumstances, therefore allowing us to hack config.mk
>> to allow for such atrocities to go on.
>
> Yes to CONFIG_NETWORK_SECMARK, No to CONFIG_NET_DMA.

Then I take it you haven't yet used this feature:


config NETWORK_SECMARK
        bool "Security Marking"
        help
          This enables security marking of network packets, similar
          to nfmark, but designated for security purposes.
          If you are unsure how to answer this question, answer N.

Which you seem to be able to use if you enable and use:


config NF_CONNTRACK_SECMARK
        bool  'Connection tracking security mark support'
        depends on NETWORK_SECMARK
        default m if NETFILTER_ADVANCED=n
        help
          This option enables security markings to be applied to
          connections.  Typically they are copied to connections from
          packets using the CONNSECMARK target and copied back from
          connections to packets with the same target, with the packets
          being originally labeled via SECMARK.

          If unsure, say 'N'.

or:

config NETFILTER_XT_TARGET_SECMARK
        tristate '"SECMARK" target support'
        depends on NETWORK_SECMARK
        default m if NETFILTER_ADVANCED=n
        help
          The SECMARK target allows security marking of network
          packets, for use with security subsystems.

          To compile it as a module, choose M here.  If unsure, say N.

Not like I have any clue what the hell this is used for despite the explanation.

  Luis
