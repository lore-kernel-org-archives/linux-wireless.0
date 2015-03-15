Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.183]:13084 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbbCOVUy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 17:20:54 -0400
Date: Sun, 15 Mar 2015 22:20:51 +0100
From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
To: =?UTF-8?B?SsO8cmdlbg==?= Bausa <juergen.Bausa@online.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Broadcom 43340
Message-ID: <20150315222051.7d614056@mir> (sfid-20150315_222058_032936_3CD12631)
In-Reply-To: <loom.20150315T213441-211@post.gmane.org>
References: <550482A2.3080803@gmail.com>
	<55048833.90408@broadcom.com>
	<55048BB1.9080906@gmail.com>
	<550491DA.6030105@broadcom.com>
	<55049507.6040209@gmail.com>
	<20150314213907.3f1167bb@mir>
	<5504B29F.8000305@gmail.com>
	<55056EFB.9020100@broadcom.com>
	<loom.20150315T213441-211@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On 2015-03-15, Jürgen Bausa wrote:
> Arend van Spriel <arend@...> writes:
> > On 03/14/15 23:13, Ochal Christophe wrote:
[...]
> would be nice, if you could make it clear.
> 
> I am in the exact some position (asus x205 with linux 4.0 rc3) but my
> /sys/firmware/efi/efivars/ is empty. I am running debian jessie with a
> kernel taken from ubuntu. Am I missing something? Even loading efivars via
> modprobe doesnt change a thing.

You need to have efivarfs mounted, which Debian/jessie and systemd 
should do by default (it certainly does, at least when booted in UEFI
mode - you probably won't have access to it in BIOS CSM mode):

$ grep efivarfs /proc/mounts 
efivarfs /sys/firmware/efi/efivars efivarfs rw,nosuid,nodev,noexec,relatime 0 0

If it isn't for some weird reason, you'll have to mount it by hand.

# mount -t efivarfs -o rw,nosuid,nodev,noexec,relatime efivarfs /sys/firmware/efi/efivars

Regards
	Stefan Lippers-Hollmann
