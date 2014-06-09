Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:52533 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaFIM1Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2014 08:27:16 -0400
Received: by mail-qa0-f42.google.com with SMTP id j5so7824660qaq.29
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jun 2014 05:27:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALhHN=pRskkXn_Li2n+hOM24t1QHwHi_E_ozc726Gh0jnuc5=w@mail.gmail.com>
References: <1399624824-9204-1-git-send-email-janusz.dziedzic@tieto.com>
	<CAB=NE6UuZFDLdA-KW=ohaFwXjj_3wSY84cj3-KPO7HoKREPHOA@mail.gmail.com>
	<20140520142453.GB13981@tuxdriver.com>
	<CALhHN=qtxwww9hQ7XxK8tan3+4eSoXo3D_g9YLD0QhQDPcDUmg@mail.gmail.com>
	<20140520180832.GD13981@tuxdriver.com>
	<1400610273.4474.6.camel@jlt4.sipsolutions.net>
	<CAB=NE6WiuydxR62dvua_OEyV+sqxvH8aOUHOBLS3ePz1dGCLAw@mail.gmail.com>
	<1400688233.4136.8.camel@jlt4.sipsolutions.net>
	<53956986.8070603@openwrt.org>
	<CALhHN=pRskkXn_Li2n+hOM24t1QHwHi_E_ozc726Gh0jnuc5=w@mail.gmail.com>
Date: Mon, 9 Jun 2014 14:27:15 +0200
Message-ID: <CALhHN=ogLffM+esRwbNdvLHjq6RikpZBsduf58pRY0xVqjNqSA@mail.gmail.com> (sfid-20140609_142816_655267_2AA088FC)
Subject: Re: [PATCH] wireless-regdb: add DFS CAC time parameter
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 June 2014 12:22, Janusz Dziedzic <janusz.dziedzic@tieto.com> wrote:
> On 9 June 2014 10:00, Felix Fietkau <nbd@openwrt.org> wrote:
>> On 2014-05-21 18:03, Johannes Berg wrote:
>>> On Tue, 2014-05-20 at 11:48 -0700, Luis R. Rodriguez wrote:
>>>
>>>> > I think we should, but if we can't then at least can we cut to an
>>>> > extensible format?
>>>
>>> I don't see any way to extend the format right now.
>>>
>>> There's a wrinkle with making it more extensible too though - if we do
>>> that then we must be extremely careful that future older crda versions
>>> (i.e. the next version that we're about to write) will not parse a newer
>>> extended file more permissively, so our extensions are limited anyway.
>>>
>>> Looks like the format update really is needed, which probably means we
>>> should change the scripts to generate two databases and change the
>>> filename, or so?
>> How about making the format properly extensible by reusing what we're
>> already doing to keep the kernel ABI stable? For example, we could store
>> the database in a netlink-like attribute format, with some changes to
>> make it fixed endian.
>> I'm already doing just that for a few things in OpenWrt, so I have
>> working C code for writing and parsing such a format.
>>
>> Another nice feature would be to indicate in the attributes if crda is
>> required to understand them, or if it can just continue with a warning.
>>
>> If done right, I think we can probably make this the last time we change
>> the format version.
>>
> What kind of benefit we have having binary format between crda <->
> wireless-regd (nl-based or current regulatory.bin)?
> This is additional code/work to do - why we need that?
>

This is example of /sbin/crda script I have - seems works fine (small
crda_tiny also required):

#!/bin/sh
PUBKEY=/usr/lib/crda/pubkeys/regdb_pubring.gpg
REGDB=/usr/lib/crda/db.txt
CRDA_BIN=/sbin/crda_tiny
LOG=/tmp/crda.err

gpg_verify() {
    PUBKEY=$1
    REGDB=$2
    gpg --no-default-keyring --keyring $PUBKEY --verify $REGDB
}

show_country() {
    REGDB=$1
    COUNTRY=$2

    cat $REGDB \
    | sed '
        s/#.*//
        s/^[ \t]*$//
    ' \
    | awk \
        -v ctry=$COUNTRY '

        /country/{show=0}
        /BEGIN PGP SIGNATURE/{show=0}
        /country / && $2 == ctry ":" {show=1}
        show && !/^$/
   '
}

(
/bin/date
echo "$0 called with params:"
echo "COUNTRY: $COUNTRY"
echo "DB: $REGDB"
echo "PUBKEY: $PUBKEY"
echo "CRDA: $CRDA_BIN"

gpg_verify "$PUBKEY" "$REGDB" && show_country "$REGDB" "$COUNTRY" | "$CRDA_BIN"
