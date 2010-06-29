Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47299 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab0F2QzZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 12:55:25 -0400
Received: by fxm14 with SMTP id 14so1557904fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jun 2010 09:55:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimZTGvPuWPTXSOfOjvxzQh5tSnlqNBpueASLAUF@mail.gmail.com>
References: <AANLkTimZTGvPuWPTXSOfOjvxzQh5tSnlqNBpueASLAUF@mail.gmail.com>
Date: Tue, 29 Jun 2010 12:55:22 -0400
Message-ID: <AANLkTikRH3YEoZ47ihcZyqBiwfxdBPAEgZdAzAWES8x-@mail.gmail.com>
Subject: Re: rt61pci AP performance issues
From: David Ellingsworth <david@identd.dyndns.org>
To: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/mixed; boundary=00151747c0fe5e4a26048a2e1a1f
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--00151747c0fe5e4a26048a2e1a1f
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Jun 18, 2010 at 2:02 PM, David Ellingsworth
<david@identd.dyndns.org> wrote:
> I've been trying unsuccessfully for some time to use a rt61pci based
> wireless card as an Access Point for my network. With kernel version
> 2.6.32-4 (Debian version) the AP works but has intermittent problems.
> Notably, that version continuously prints the message
> "ieee80211_tx_status: headroom too small" to my system log and the
> driver simply stops working after a random amount of time. The first
> of these errors was fixed some time ago after I reported it, but the
> other still remains, even with the latest wireless-testing driver, and
> there's no indication as to the cause of the issue. With regards to
> this issue, it appears that performance steadily drops until it
> becomes unusable. With the latest wireless-testing driver I can
> reliably reproduce this issue by trying to transfer a large file from
> my server to a client. Any help diagnosing and correcting this issue
> would be greatly appreciated.
>

I have not received a response to this issue, so I'll try to clarify
it a bit. With the latest wireless-testing tree, clients are able to
associate to my rt61pci AP but the connection fails after about 10s or
less while transferring a file. Between v2.6.32 and the latest
wireless-testing tree, there have been many changes. These changes
introduced a lot of variability in the connection speed and stability.
All of this has made bisecting this issue very difficult..

Using v2.6.32 as a "good" point and ad57b053612 (the HEAD of
wireless-testing at the time) as a "bad" point, I began bisecting. I
then compiled and tested 15 different kernels. Some of them were
remarkably better and others were extremely worse. Upon completing,
git had identified a single commit as the cause. Unfortunately, the
commit it identified had nothing to do with the rt61pci driver or the
wireless networking stack. I therefore had done something wrong during
my testing.

Fortunately, all that work did not go to waste. During my testing, I
identified c91f48d61c as being remarkably better than both v2.6.32 and
the HEAD of the wireless testing branch. At that commit, the
performance is fast and stable and much closer to the HEAD of the
wireless-testing branch. Using it as the first good position, and
bisecting only 'net/mac80211/' and 'drivers/net/wireless/rt2x00/' I
was able to identify e46754f8c9333 as the first bad commit. This
commit was a merge of another branch and consists of about four other
commits, two which directly affect mac80211.

I haven't conducted any other tests beyond what was bisected in the
attached log. Performance across all those revisions remained somewhat
fast, and my markings were based solely on client link failure. Each
bad commit resulted in the link failing after about 10s while
transferring a file. At which point, the transfer would stop, the AP
would be unreachable via pings, but the client remained associated to
the AP. About 30s after that point, the client would timeout and
re-associate to the AP reactivating the link.

Given that I limited my bisection to only the above directories, the
cause could very well be in some other commit than the one identified.
Nonetheless, I hope this additional information helps identify the
cause so that it can be corrected. There's also the chance that even
if this is caused by a change in mac80211, the rt61pci driver may
still be at fault due to unexpected behavior.

Regards,

David Ellingsworthh

--00151747c0fe5e4a26048a2e1a1f
Content-Type: application/octet-stream; name="bisect.log"
Content-Disposition: attachment; filename="bisect.log"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gb0y8r0t0

IyBiYWQ6IFthZDU3YjA1MzYxMmY0YzE3Zjk4YmNhZDgxZDM1ZTVmZjNlMmNiYmY1XSBNZXJnZSBi
cmFuY2ggJ21hc3Rlcicgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJu
ZWwvZ2l0L2xpbnZpbGxlL3dpcmVsZXNzLW5leHQtMi42CiMgZ29vZDogW2M5MWY0OGQ2MWM1YjZm
YjM2YTZmYzUwZGU5MjNkYjRkYjAwOWIwZGNdIHNmYzogU3Vydml2ZSBJU1IwPTAgYnVnIGluIHRo
ZSBzaGFyZWQgSVJRIGNhc2UKZ2l0IGJpc2VjdCBzdGFydCAnSEVBRCcgJ2M5MWY0OGQ2MWM1YjZm
YjM2YTZmYzUwZGU5MjNkYjRkYjAwOWIwZGMnICduZXQvbWFjODAyMTEvJyAnZHJpdmVycy9uZXQv
d2lyZWxlc3MvcnQyeDAwLycKIyBnb29kOiBbMDU4ODk3YTRlOTNhNmZjNmQzMzFlMmVmNTkxYjJk
NjU3MTQzMTI2NV0gbWFjODAyMTE6IGZpeCBwYWdlZCBkZWZyYWdtZW50YXRpb24KZ2l0IGJpc2Vj
dCBnb29kIDA1ODg5N2E0ZTkzYTZmYzZkMzMxZTJlZjU5MWIyZDY1NzE0MzEyNjUKIyBiYWQ6IFth
M2Y4NGNhNGI4ZGMzMWQwMDM0YThiMjMxOTRhNDQ3MDc2NmM5MzhjXSBydDJ4MDA6IEZpeCB0eXBv
IGluIHJ0MjgwMF9jb25maWdfdHhwb3dlcgpnaXQgYmlzZWN0IGJhZCBhM2Y4NGNhNGI4ZGMzMWQw
MDM0YThiMjMxOTRhNDQ3MDc2NmM5MzhjCiMgc2tpcDogWzA2NDQzZTQ2YzY1OTE1ZDc0YjAzZmUx
ZGUxMGMwMDc0OGU0NzA2ZWVdIHJ0MngwMDogRml4IEhUNDAgb3BlcmF0aW9uIGluIHJ0MjgwMC4K
Z2l0IGJpc2VjdCBza2lwIDA2NDQzZTQ2YzY1OTE1ZDc0YjAzZmUxZGUxMGMwMDc0OGU0NzA2ZWUK
IyBiYWQ6IFszYjUxY2M5OTZlODFkOGExMTM0MTZkODA5NGZhNGE4OGY4MzYwYTUxXSBNZXJnZSBi
cmFuY2ggJ21hc3RlcicgaW50byBmb3ItZGF2ZW0KZ2l0IGJpc2VjdCBiYWQgM2I1MWNjOTk2ZTgx
ZDhhMTEzNDE2ZDgwOTRmYTRhODhmODM2MGE1MQojIGdvb2Q6IFs0YTM1ZWNmOGJmMWM0YjAzOTUw
M2ZhNTU0MTAwZmU4NWM3NjFkZTc2XSBNZXJnZSBicmFuY2ggJ21hc3Rlcicgb2YgbWFzdGVyLmtl
cm5lbC5vcmc6L3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9kYXZlbS9uZXQtMi42CmdpdCBiaXNl
Y3QgZ29vZCA0YTM1ZWNmOGJmMWM0YjAzOTUwM2ZhNTU0MTAwZmU4NWM3NjFkZTc2CiMgZ29vZDog
WzRhMTAzMmZhYWM5NGViYmY2NDc0NjBhZTNlMDZmYzIxMTQ2ZWIyODBdIE1lcmdlIGJyYW5jaCAn
bWFzdGVyJyBvZiAvaG9tZS9kYXZlbS9zcmMvR0lUL2xpbnV4LTIuNi8KZ2l0IGJpc2VjdCBnb29k
IDRhMTAzMmZhYWM5NGViYmY2NDc0NjBhZTNlMDZmYzIxMTQ2ZWIyODAKIyBnb29kOiBbNWMwMWQ1
NjY5MzU2ZTEzZjBmYjQ2ODk0NGMxZGQ0YzZhN2U5NzhhZF0gTWVyZ2UgYnJhbmNoICdtYXN0ZXIn
IG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9saW52aWxs
ZS93aXJlbGVzcy1uZXh0LTIuNiBpbnRvIGZvci1kYXZlbQpnaXQgYmlzZWN0IGdvb2QgNWMwMWQ1
NjY5MzU2ZTEzZjBmYjQ2ODk0NGMxZGQ0YzZhN2U5NzhhZAojIGJhZDogWzg3ZWIzNjcwMDM4ODdj
ZGM4MWE1ZDE4M2VmZWEyMjdiNWI0ODg5NjFdIE1lcmdlIGJyYW5jaCAnbWFzdGVyJyBvZiBtYXN0
ZXIua2VybmVsLm9yZzovcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2RhdmVtL25ldC0yLjYKZ2l0
IGJpc2VjdCBiYWQgODdlYjM2NzAwMzg4N2NkYzgxYTVkMTgzZWZlYTIyN2I1YjQ4ODk2MQojIGJh
ZDogW2U0Njc1NGY4YzkzMzMxNzBmMTE3ODBkOGUzYTcwZGExYjFhODgzMzhdIE1lcmdlIGJyYW5j
aCAnbWFzdGVyJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9n
aXQvbGludmlsbGUvd2lyZWxlc3MtMi42CmdpdCBiaXNlY3QgYmFkIGU0Njc1NGY4YzkzMzMxNzBm
MTE3ODBkOGUzYTcwZGExYjFhODgzMzgK
--00151747c0fe5e4a26048a2e1a1f--
