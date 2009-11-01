Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37929 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753021AbZKAR7y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Nov 2009 12:59:54 -0500
Message-ID: <4AEDCCA0.8050709@gmx.net>
Date: Sun, 01 Nov 2009 19:00:00 +0100
From: Frank Schaefer <schaefer.frank@gmx.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: linux-usb@vger.kernel.org, johannes@sipsolutions.net,
	chunkeey@web.de
Subject: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB N devices
 in cdrom mode
References: <200910171606.02961.oliver@neukum.org> <Pine.LNX.4.44L0.0910171130550.25594-100000@netrider.rowland.org> <20091017220313.GH24502@one-eyed-alien.net> <4ADC3657.6080906@gmx.net>
In-Reply-To: <4ADC3657.6080906@gmx.net>
Content-Type: multipart/mixed;
 boundary="------------000006070502040201000502"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000006070502040201000502
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Frank Schaefer schrieb:
> Matthew Dharm schrieb:
>   
>> On Sat, Oct 17, 2009 at 11:34:07AM -0400, Alan Stern wrote:
>>   
>>     
>>> On Sat, 17 Oct 2009, Oliver Neukum wrote:
>>>
>>>     
>>>       
>>>> Am Samstag, 17. Oktober 2009 15:14:28 schrieb Frank Schaefer:
>>>>       
>>>>         
>>>>> I can think of multiple solutions for this, my first questions are:
>>>>> Is there already a common solution for these devices in the kernel ?
>>>>> How widespread is this bad habit of device-design ? So far, the only
>>>>> devices I know are
>>>>>         
>>>>>           
>>>> This is usually handled by the modeswitch tool outside the kernel.
>>>>       
>>>>         
>>> Alternatively, you may be able to force the device to switch modes by 
>>> running the "eject" program on it.
>>>
>>> There is mode-switching code in the kernel for a few devices.  The 
>>> current trend is to move this out of the kernel and let user programs 
>>> be responsible for it.
>>>     
>>>       
>> If you go with the current trend, then you probably will want to write some
>> UDEV rules to recognize these devices and issue the mode-changing command
>> (either modeswitch or eject).
>>
>> Matt
>>   
>>     
> Thanks for your replies, I really didn't know that there are so many
> devices showing this behavior.
>
> On Windows, AVM does the fast-eject for its devices with a small
> filter-driver avmeject.sys.
> I will try to find out the "magic sequence" needed for the mode-switch
> with a USB-logger.
>
> Regards,
> Frank
>   
I finally found the "magic" sequence.
In the meantime I've been thinking a lot (too much ?) about HOW and
WHERE to do the mode-switching.
The mailing-list-archieves were really inspiring, maybe you remember the
discussion about Tejun Heos' patches in april 2008.
The conclusion was that there is no clearly preferable way to do this
and that compromises are inevitable.

The attached patch adds the mode-switching-procedure to the WLAN-driver
(ar9170usb) and disables the storage device in the usb-storage-driver.

I really think the mode-switching should be done in the kernel and not
in user-space for reasons of usability.
Doing it in the driver means putting the code for these device together
in a single place.
It also doesn't "pollute" the driver with much code (adds a single
usb_bulk_msg()).
Another benfit is that it binds the mode-switching to the driver. If the
driver is blacklisted/not used, there will be no mode-switching.
If there would be a way to keep the usb-storage-driver enabled as
"fallback-driver" it would be an almost perfect solution...

Regards,
Frank


--------------000006070502040201000502
Content-Type: application/mbox;
 name="0001-ar9170usb-add-mode-switching-for-AVM-Fritz-WLAN-USB.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename*0="0001-ar9170usb-add-mode-switching-for-AVM-Fritz-WLAN-USB.pat";
 filename*1="ch"

RnJvbSAzNzJlOWYzZTZkNjFlMTk1MzM5ZDk1NWExZDc1YjE1YTIzZGRlNjI0IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBGcmFuayBTY2hhZWZlciA8c2NoYWVmZXIuZnJhbmtA
Z214Lm5ldD4KRGF0ZTogU3VuLCAxIE5vdiAyMDA5IDE3OjMxOjE0ICswMTAwClN1YmplY3Q6
IFtQQVRDSF0gYXI5MTcwdXNiOiBhZGQgbW9kZS1zd2l0Y2hpbmcgZm9yIEFWTSBGcml0eiFX
TEFOIFVTQiBOIGRldmljZXMgaW4gY2Ryb20gbW9kZQoKVGhlIGRldmljZXMKCjA1N2M6ODQw
MSAgICBBVk0gRnJpdHohV0xBTiBVU0IgTgowNTdjOjg0MDIgICAgQVZNIEZyaXR6IVdMQU4g
VVNCIE4gMi40CgpoYXZlIGEgYnVpbHQtaW4gY2Ryb20tbW9kZToKV2hlbiB0aGV5IGFyZSBw
bHVnZ2VkIGluLCB0aGV5IGFwcGVhciBhcyByZWFkLW9ubHkgVVNCLW1hc3Mtc3RvcmFnZS1k
ZXZpY2UgKFNDU0ktQ0RST00sIGlzbzk2NjApIDA1N2M6ODRmZiBjb250YWluaW5nIFdpbmRv
d3MgZHJpdmVyIGZpbGVzLgpJIHRha2VzIGFib3V0IDIgbWludXRlcyB1bnRpbCB0aGUgZmly
bXdhcmUgdGltZXMtb3V0IGFuZCBkaXNjb25uZWN0cyB0aGVzZSBkZXZpY2VzLgpUaGVuIFVT
Qi1wcm9kdWN0LWlkIGNoYW5nZXMgYW5kIHRoZXkgYXBwZWFyIGFnYWluIGFzIFdMQU4tZGV2
aWNlLgoKV2UgZG9uJ3QgbmVlZCB0aGUgV2luZG93cyBkcml2ZXJzIGFuZCB3ZSBqdXN0IHdh
bnQgYSBXTEFOLWRldmljZSB3aGljaCBpcyBpbW1lZGlhdGVseSBhdmFpbGFibGUuCgpUaGlz
IHBhdGNoIGFkZHMgdGhlIG5lY2Vzc2FyeSBtb2RlLXN3aXRjaGluZy0vZmFzdC1lamVjdC1w
cm9jZWR1cmUgdG8gdGhlIGRyaXZlci4KClRlc3RlZCB3aXRoIGRldmljZSAwNTdjOjg0MDEu
CgpTaWduZWQtb2ZmLWJ5OiBGcmFuayBTY2hhZWZlciA8c2NoYWVmZXIuZnJhbmtAZ214Lm5l
dD4KLS0tCiBkcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXI5MTcwL3VzYi5jIHwgICA1NyAr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKystLQogZHJpdmVycy91c2Ivc3RvcmFnZS91
c3VhbC10YWJsZXMuYyAgICB8ICAgIDQgKysKIDIgZmlsZXMgY2hhbmdlZCwgNTcgaW5zZXJ0
aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJl
bGVzcy9hdGgvYXI5MTcwL3VzYi5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2FyOTE3
MC91c2IuYwppbmRleCBlOTc0ZTU4Li44YWI3NmIzIDEwMDY0NAotLS0gYS9kcml2ZXJzL25l
dC93aXJlbGVzcy9hdGgvYXI5MTcwL3VzYi5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L2F0aC9hcjkxNzAvdXNiLmMKQEAgLTg4LDEwICs4OCwxMiBAQCBzdGF0aWMgc3RydWN0IHVz
Yl9kZXZpY2VfaWQgYXI5MTcwX3VzYl9pZHNbXSA9IHsKIAl7IFVTQl9ERVZJQ0UoMHgyMDE5
LCAweDUzMDQpIH0sCiAJLyogSU8tRGF0YSBXTkdETlVTMiAqLwogCXsgVVNCX0RFVklDRSgw
eDA0YmIsIDB4MDkzZikgfSwKKwkvKiBBVk0gRlJJVFohV0xBTiBVU0IgU3RpY2sgTiAoMi40
KSBpbiBjZHJvbSBtb2RlICovCisJeyBVU0JfREVWSUNFKDB4MDU3YywgMHg4NGZmKSB9LAog
CS8qIEFWTSBGUklUWiFXTEFOIFVTQiBTdGljayBOICovCi0JeyBVU0JfREVWSUNFKDB4MDU3
QywgMHg4NDAxKSB9LAorCXsgVVNCX0RFVklDRSgweDA1N2MsIDB4ODQwMSkgfSwKIAkvKiBB
Vk0gRlJJVFohV0xBTiBVU0IgU3RpY2sgTiAyLjQgKi8KLQl7IFVTQl9ERVZJQ0UoMHgwNTdD
LCAweDg0MDIpLCAuZHJpdmVyX2luZm8gPSBBUjkxNzBfUkVRX0ZXMV9PTkxZIH0sCisJeyBV
U0JfREVWSUNFKDB4MDU3YywgMHg4NDAyKSwgLmRyaXZlcl9pbmZvID0gQVI5MTcwX1JFUV9G
VzFfT05MWSB9LAogCiAJLyogdGVybWluYXRlICovCiAJe30KQEAgLTc2Miw2ICs3NjQsNDMg
QEAgc3RhdGljIGJvb2wgYXI5MTcwX3JlcXVpcmVzX29uZV9zdGFnZShjb25zdCBzdHJ1Y3Qg
dXNiX2RldmljZV9pZCAqaWQpCiAJcmV0dXJuIGZhbHNlOwogfQogCitzdGF0aWMgdm9pZCBh
cjkxNzBfdXNiX2F2bV9jZHJvbV9mYXN0X2VqZWN0KHN0cnVjdCB1c2JfaW50ZXJmYWNlICpp
bnRmLAorCQkJCQkgICAgc3RydWN0IHVzYl9kZXZpY2UgKnVkZXYpCit7CisJY29uc3QgdW5z
aWduZWQgY2hhciBzY3NpX3N0b3BfdW5pdFszMV0gPSB7CisJMHg1NSwgMHg1MywgMHg0Miwg
MHg0MywgMHgwMCwgMHgwMCwgMHgwMCwgMHgwMCwgMHgwMCwgMHgwMCwgMHgwMCwgMHgwMCwK
KwkweDAwLCAweDAwLCAweDA2LCAweDFCLAkweDAwLCAweDAwLCAweDAwLCAweEZGLCAweDAw
LCAweDAwLCAweDAwLCAweDAwLAorCTB4MDAsIDB4MDAsIDB4MDAsIDB4MDAsIDB4MDAsIDB4
MDAsIDB4MDAgfTsKKwkKKwlfX3U4IGVwQWRkcjsKKwl1bnNpZ25lZCBjaGFyICp0bXBidWY7
CisJaW50IGFjdHVhbF9sZW47CisKKwlwcmludGsoS0VSTl9JTkZPICJhcjkxNzB1c2I6IEZv
dW5kIGRldmljZSBBVk0gRlJJVFohV0xBTiBVU0IgTiBpbiAiCisJCQkgImNkcm9tIG1vZGUu
IERvaW5nIGZhc3QgZWplY3QuXG4iKTsKKwl0bXBidWYgPSAodW5zaWduZWQgY2hhciopIGtt
YWxsb2Moc2l6ZW9mIChzY3NpX3N0b3BfdW5pdCksIEdGUF9LRVJORUwpOworCWlmICh0bXBi
dWYgPT0gTlVMTCkKKwkJZ290byBlcnJvcjsKKwltZW1jcHkodG1wYnVmLCBzY3NpX3N0b3Bf
dW5pdCwgc2l6ZW9mKHNjc2lfc3RvcF91bml0KSk7CisJZXBBZGRyID0gaW50Zi0+YWx0c2V0
dGluZ1swXS5lbmRwb2ludFswXS5kZXNjLmJFbmRwb2ludEFkZHJlc3M7CisJaWYgKHVzYl9i
dWxrX21zZyh1ZGV2LAorCQkJIHVzYl9zbmRidWxrcGlwZSh1ZGV2LCBlcEFkZHIpLAorCQkJ
IHRtcGJ1ZiwKKwkJCSBzaXplb2Yoc2NzaV9zdG9wX3VuaXQpLAorCQkJICZhY3R1YWxfbGVu
LAorCQkJIDUgKiBIWikgPCAwKQorCQlnb3RvIGVycm9yOworCWlmIChhY3R1YWxfbGVuICE9
IHNpemVvZihzY3NpX3N0b3BfdW5pdCkpCisJCWdvdG8gZXJyb3I7CisJa2ZyZWUodG1wYnVm
KTsKKwlyZXR1cm47CitlcnJvcjoKKwlpZiAodG1wYnVmKQorCQlrZnJlZSh0bXBidWYpOwor
CXByaW50ayhLRVJOX0VSUiAiYXI5MTcwdXNiOiBGYXN0IGVqZWN0IGZhaWxlZC4gRGV2aWNl
IHNob3VsZCB0aW1lb3V0ICIKKwkJCSJpbiB+MiBtaW4uIGFuZCBlamVjdCBpdHNlbGYuXG4i
KTsKK30KKwogc3RhdGljIGludCBhcjkxNzBfdXNiX3Byb2JlKHN0cnVjdCB1c2JfaW50ZXJm
YWNlICppbnRmLAogCQkJY29uc3Qgc3RydWN0IHVzYl9kZXZpY2VfaWQgKmlkKQogewpAQCAt
NzcwLDE0ICs4MDksMjQgQEAgc3RhdGljIGludCBhcjkxNzBfdXNiX3Byb2JlKHN0cnVjdCB1
c2JfaW50ZXJmYWNlICppbnRmLAogCXN0cnVjdCB1c2JfZGV2aWNlICp1ZGV2OwogCWludCBl
cnI7CiAKKwl1ZGV2ID0gaW50ZXJmYWNlX3RvX3VzYmRldihpbnRmKTsKKwl1c2JfZ2V0X2Rl
dih1ZGV2KTsKKworCS8qIEZhc3QgZWplY3QgZm9yIEFWTSBGUklUWiFXTEFOIFVTQiBTdGlj
ayBOICgyLjQpIGluIGNkcm9tIG1vZGUgKi8KKwlpZiAoKGxlMTZfdG9fY3B1KHVkZXYtPmRl
c2NyaXB0b3IuaWRWZW5kb3IpID09IDB4MDU3QykKKwkgICAgJiYgKGxlMTZfdG9fY3B1KHVk
ZXYtPmRlc2NyaXB0b3IuaWRQcm9kdWN0KSA9PSAweDg0RkYpKSB7CisJCWFyOTE3MF91c2Jf
YXZtX2Nkcm9tX2Zhc3RfZWplY3QoaW50ZiwgdWRldik7CisJCXVzYl9wdXRfZGV2KHVkZXYp
OworCQlyZXR1cm4gMDsKKwl9CisJLyogTk9URTogZGV2aWNlIHdpbGwgdmFuaXNoIGFuZCBy
ZWFwcGVhciB3aXRoIFBJRCAweDg0MDEgb3IgMHg4NDAyICovCisKIAlhcnUgPSBhcjkxNzBf
YWxsb2Moc2l6ZW9mKCphcnUpKTsKIAlpZiAoSVNfRVJSKGFydSkpIHsKIAkJZXJyID0gUFRS
X0VSUihhcnUpOwogCQlnb3RvIG91dDsKIAl9CiAKLQl1ZGV2ID0gaW50ZXJmYWNlX3RvX3Vz
YmRldihpbnRmKTsKLQl1c2JfZ2V0X2Rldih1ZGV2KTsKIAlhcnUtPnVkZXYgPSB1ZGV2Owog
CWFydS0+aW50ZiA9IGludGY7CiAJYXIgPSAmYXJ1LT5jb21tb247CmRpZmYgLS1naXQgYS9k
cml2ZXJzL3VzYi9zdG9yYWdlL3VzdWFsLXRhYmxlcy5jIGIvZHJpdmVycy91c2Ivc3RvcmFn
ZS91c3VhbC10YWJsZXMuYwppbmRleCA0NjhiZGU3Li45OTYyMzcxIDEwMDY0NAotLS0gYS9k
cml2ZXJzL3VzYi9zdG9yYWdlL3VzdWFsLXRhYmxlcy5jCisrKyBiL2RyaXZlcnMvdXNiL3N0
b3JhZ2UvdXN1YWwtdGFibGVzLmMKQEAgLTg4LDYgKzg4LDEwIEBAIHN0YXRpYyBzdHJ1Y3Qg
aWdub3JlX2VudHJ5IGlnbm9yZV9pZHNbXSA9IHsKICMJaW5jbHVkZSAidW51c3VhbF9zZGRy
MDkuaCIKICMJaW5jbHVkZSAidW51c3VhbF9zZGRyNTUuaCIKICMJaW5jbHVkZSAidW51c3Vh
bF91c2JhdC5oIgorVU5VU1VBTF9ERVYoICAweDA1N2MsIDB4ODRmZiwgMHgwMDAwLCAweGZm
ZmYsCisJCSJBVk0iLAorCQkiRnJpdHohV0xBTiBVU0IgTiAoMi40KSBpbiBjZHJvbSBtb2Rl
IiwKKwkJVVNfU0NfREVWSUNFLCBVU19QUl9ERVZJQ0UsIE5VTEwsIDApLAogCXsgfQkJLyog
VGVybWluYXRpbmcgZW50cnkgKi8KIH07CiAKLS0gCjEuNi4wLjIKCg==
--------------000006070502040201000502--
