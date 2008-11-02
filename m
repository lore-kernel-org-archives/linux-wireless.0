Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:21351 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbYKBJKF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 04:10:05 -0500
Received: by wf-out-1314.google.com with SMTP id 27so1993559wfd.4
        for <linux-wireless@vger.kernel.org>; Sun, 02 Nov 2008 01:10:04 -0800 (PST)
Message-ID: <40f31dec0811020110t6ec94c57gd91adc44f759bf45@mail.gmail.com> (sfid-20081102_101012_936548_2E60794F)
Date: Sun, 2 Nov 2008 11:10:04 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: wireless-testing commit eb9d4e8399181357cb6f6625ba7f849987432c6c causes stalls
Cc: tim.gardner@canonical.com, mick@madwifi.org,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Bob Copeland" <me@bobcopeland.com>
In-Reply-To: <40f31dec0811020132o640afa49u56791b4122013463@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_10944_2368216.1225617004597"
References: <4908B754.1050400@tpi.com>
	 <43e72e890811011419k460b11e0he08d66022cbd606e@mail.gmail.com>
	 <40f31dec0811020132o640afa49u56791b4122013463@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_10944_2368216.1225617004597
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2008/11/2 Nick Kossifidis <mickflemm@gmail.com>:
> 2008/11/1 Luis R. Rodriguez <mcgrof@gmail.com>:
>> On Wed, Oct 29, 2008 at 12:19 PM, Tim Gardner <tcanonical@tpi.com> wrote:
>>> This commit 'ath5k: Update interrupt masking code' causes stalls under
>>> load when built using compat-wireless on 2.6.27. There is no output from
>>> dmesg, but it occasionally recovers and moves a few more packets before
>>> stalling again. Luis suggested reverting
>>> eb9d4e8399181357cb6f6625ba7f849987432c6c which I did. Now it appears to
>>> work normally.
>>>
>>> I also think this patch should be broken into multiple pieces. There
>>> appear to be at least 3 functional changes addressed in this single patch.
>>
>> Agreed, I just tested with the latest wireless-testing and the issue
>> is still present. I reviewed the commit but its a big too large to pin
>> point the exact issue, my AR5414 goes up but then quickly becomes
>> unusable. Nick how about we revert this and you can then split this up
>> into a good number of patches to make the review easier and also to be
>> able to pin point the exact issue better?
>>
>> The SHA1 remains the same but just in case the title of the patch is:
>>
>>   ath5k: Update interrupt masking code
>>
>> With it reverted I'm cruising and can ditch MadWifi completely, which
>> is the idea.
>>
>>  Luis
>>
>

Can you test the attached patch ?

It works for me (tested on a AR5413)...

makis linux # iperf -s
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  4] local 192.168.1.104 port 5001 connected with 192.168.1.10 port 43192
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-10.6 sec  21.8 MBytes  17.2 Mbits/sec

makis linux # iwconfig
lo        no wireless extensions.

eth0      no wireless extensions.

wmaster0  no wireless extensions.

wlan1     IEEE 802.11abg  ESSID:"MickFlemm"
          Mode:Managed  Frequency:2.437 GHz  Access Point: 00:1D:7E:AE:95:44
          Bit Rate=24 Mb/s   Tx-Power=20 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
          Encryption key:off
          Power Management:off
          Link Quality=97/100  Signal level:-60 dBm  Noise level=-94 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0





-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick

------=_Part_10944_2368216.1225617004597
Content-Type: text/x-patch; name=ath5k-imr.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fn1goqdg0
Content-Disposition: attachment; filename=ath5k-imr.patch

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aDVrL2Jhc2UuYyBiL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL2F0aDVrL2Jhc2UuYwppbmRleCA1ZWY4Y2M0Li5mNWY0NmZlIDEwMDY0NAot
LS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGg1ay9iYXNlLmMKKysrIGIvZHJpdmVycy9uZXQv
d2lyZWxlc3MvYXRoNWsvYmFzZS5jCkBAIC0yMjE5LDkgKzIyMTksOSBAQCBhdGg1a19pbml0KHN0
cnVjdCBhdGg1a19zb2Z0YyAqc2MsIGJvb2wgaXNfcmVzdW1lKQogCSAqLwogCXNjLT5jdXJjaGFu
ID0gc2MtPmh3LT5jb25mLmNoYW5uZWw7CiAJc2MtPmN1cmJhbmQgPSAmc2MtPnNiYW5kc1tzYy0+
Y3VyY2hhbi0+YmFuZF07Ci0Jc2MtPmltYXNrID0gQVI1S19JTlRfUlhPSyB8IEFSNUtfSU5UX1RY
T0sgfCBBUjVLX0lOVF9SWEVPTCB8Ci0JCUFSNUtfSU5UX1JYT1JOIHwgQVI1S19JTlRfRkFUQUwg
fCBBUjVLX0lOVF9HTE9CQUwgfAotCQlBUjVLX0lOVF9NSUI7CisJc2MtPmltYXNrID0gQVI1S19J
TlRfUlhPSyB8IEFSNUtfSU5UX1JYRVJSIHwgQVI1S19JTlRfUlhFT0wgfAorCQlBUjVLX0lOVF9S
WE9STiB8IEFSNUtfSU5UX1RYREVTQyB8IEFSNUtfSU5UX1RYRU9MIHwKKwkJQVI1S19JTlRfRkFU
QUwgfCBBUjVLX0lOVF9HTE9CQUwgfCBBUjVLX0lOVF9NSUI7CiAJcmV0ID0gYXRoNWtfcmVzZXQo
c2MsIGZhbHNlLCBmYWxzZSk7CiAJaWYgKHJldCkKIAkJZ290byBkb25lOwo=
------=_Part_10944_2368216.1225617004597--
